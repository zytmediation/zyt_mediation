package com.zyt.mediation;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.StandardMessageCodec;
import mobi.android.ZYTMediationSDK;
import mobi.android.base.ComponentHolder;
import mobi.android.dsp.DspInterstitialByNativeActivity;

/**
 * MediationFlutterPlugin
 */
public class MediationFlutterPlugin extends BasePlugin implements FlutterPlugin, ActivityAware {
    private MethodChannel channel;
    private Context mContext;
    private Activity mActivity;
    private Method onResumeMethod;
    private Field field;

    public MediationFlutterPlugin() {
    }

    public MediationFlutterPlugin(Context mContext) {
        this.mContext = mContext;
    }

    public MediationFlutterPlugin(MethodChannel channel) {
        this.channel = channel;
    }

    public MediationFlutterPlugin(MethodChannel channel, Context mContext) {
        this.channel = channel;
        this.mContext = mContext;
    }

    public MediationFlutterPlugin(MethodChannel channel, Context mContext, Activity mActivity) {
        this.channel = channel;
        this.mContext = mContext;
        this.mActivity = mActivity;
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        DartExecutor dartExecutor = flutterPluginBinding.getFlutterEngine().getDartExecutor();
        mContext = flutterPluginBinding.getApplicationContext();

        channel = new MethodChannel(dartExecutor, P_MEDIATION_FLUTTER);
        channel.setMethodCallHandler(this);

        // reward channel
        final MethodChannel rewardChannel = new MethodChannel(dartExecutor, P_REWARD);
        rewardChannel.setMethodCallHandler(new RewardPlugin(dartExecutor));

        // interstitial channel
        final MethodChannel interstitialChannel = new MethodChannel(dartExecutor, P_INTERSTITIAL);
        interstitialChannel.setMethodCallHandler(new InterstitialPlugin(dartExecutor));

        // banner channel
        final MethodChannel bannerChannel = new MethodChannel(dartExecutor, P_BANNER);
        bannerChannel.setMethodCallHandler(new BannerPlugin(dartExecutor));

        flutterPluginBinding
                .getPlatformViewRegistry().
                registerViewFactory(V_BANNER, new BannerPlatformViewFactory(StandardMessageCodec.INSTANCE, dartExecutor));
        flutterPluginBinding
                .getPlatformViewRegistry().
                registerViewFactory(V_NATIVE, new NativePlatformViewFactory(StandardMessageCodec.INSTANCE, dartExecutor));
        observerInterstitialNativeActivity(mContext);
    }

    /**
     * 兼容1.12以下版本代码
     */
    public static void registerWith(Registrar registrar) {
        ComponentHolder.setUnity(true);
        ComponentHolder.setUnityActivity(registrar.activity());
        BinaryMessenger messenger = registrar.messenger();
        final MethodChannel channel = new MethodChannel(messenger, P_MEDIATION_FLUTTER);
        channel.setMethodCallHandler(new MediationFlutterPlugin(channel, registrar.context(), registrar.activity()));

        // reward channel
        final MethodChannel rewardChannel = new MethodChannel(messenger, P_REWARD);
        rewardChannel.setMethodCallHandler(new RewardPlugin(registrar.messenger()));

        // interstitial channel
        final MethodChannel interstitialChannel = new MethodChannel(messenger, P_INTERSTITIAL);
        interstitialChannel.setMethodCallHandler(new InterstitialPlugin(registrar.messenger()));
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case M_MEDIATION_FLUTTER_INITIALIZE:
                initMediationSdk(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        removeObserver(mContext);
    }

    /**
     * sdk初始化
     *
     * @param call
     * @param result
     */
    private void initMediationSdk(MethodCall call, Result result) {
        String appId = call.argument(A_INITIALIZE_APP_ID);
        String pubKey = call.argument(A_INITIALIZE_PUB_KEY);
        if (TextUtils.isEmpty(appId) || mContext == null) {
            onInitFailure();
            result.error("error", "app id is empty or mContext is null", null);
            return;
        }
        ZYTMediationSDK.initSdk(mContext, appId, pubKey, new ZYTMediationSDK.InitListener() {
            @Override
            public void initSuccess() {
                onInitSuccess();
            }

            @Override
            public void initFail() {
                onInitFailure();
            }
        });
        result.success(null);
    }

    public void onInitSuccess() {
        if (channel != null) {
            channel.invokeMethod(C_INITIALIZE_SUCCESS, null);
        }
    }

    public void onInitFailure() {
        if (channel != null) {
            channel.invokeMethod(C_INITIALIZE_FAILURE, null);
        }
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        ComponentHolder.setUnity(true);
        ComponentHolder.setUnityActivity(binding.getActivity());

        mActivity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {
    }

    private void invoke(Activity activity) {
        if (activity == null) {
            return;
        }
        try {
            Field field = refDelegateByFlutterActivity(activity.getClass());
            Method method = refOnResumeMethod();
            if (field != null && method != null) {
                method.invoke(field.get(activity));
            }
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (Exception ignored) {
        }
    }

    private Field refDelegateByFlutterActivity(Class<?> clazz) {
        if (field != null) {
            return field;
        }
        Field[] fields = clazz.getFields();
        Field[] declaredFields = clazz.getDeclaredFields();
        for (Field field : fields) {
            if (field != null && "delegate".equals(field.getName())) {
                field.setAccessible(true);
                this.field = field;
                return field;
            }
        }
        for (Field field : declaredFields) {
            if (field != null && "delegate".equals(field.getName())) {
                field.setAccessible(true);
                this.field = field;
                return field;
            }
        }
        Class<?> superclass = clazz.getSuperclass();
        if (superclass != null) {
            return refDelegateByFlutterActivity(superclass);
        }
        return null;
    }

    private Method refOnResumeMethod() {
        if (onResumeMethod != null) {
            return onResumeMethod;
        }
        Class<?> aClass = null;
        try {
            aClass = Class.forName("io.flutter.embedding.android.FlutterActivityAndFragmentDelegate");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        if (aClass != null) {
            try {
                onResumeMethod = aClass.getDeclaredMethod("onResume");
                onResumeMethod.setAccessible(true);
            } catch (NoSuchMethodException e) {
                e.printStackTrace();
            } catch (Exception ignored) {
            }
        }
        return onResumeMethod;
    }

    Application.ActivityLifecycleCallbacks activityLifecycleCallbacks = new Application.ActivityLifecycleCallbacks() {
        @Override
        public void onActivityCreated(Activity activity, Bundle savedInstanceState) {

        }

        @Override
        public void onActivityStarted(Activity activity) {

        }

        @Override
        public void onActivityResumed(Activity activity) {

        }

        @Override
        public void onActivityPaused(Activity activity) {

        }

        @Override
        public void onActivityStopped(Activity activity) {
            if (activity instanceof DspInterstitialByNativeActivity) {
                invoke(mActivity);
            }
        }

        @Override
        public void onActivitySaveInstanceState(Activity activity, Bundle outState) {

        }

        @Override
        public void onActivityDestroyed(Activity activity) {

        }
    };

    private void observerInterstitialNativeActivity(Context context) {
        if (context == null) {
            return;
        }
        Context applicationContext = context.getApplicationContext();
        if (applicationContext instanceof Application) {
            ((Application) applicationContext).registerActivityLifecycleCallbacks(activityLifecycleCallbacks);
        }
    }

    private void removeObserver(Context context) {
        if (context == null) {
            return;
        }
        Context applicationContext = context.getApplicationContext();
        if (applicationContext instanceof Application) {
            ((Application) applicationContext).unregisterActivityLifecycleCallbacks(activityLifecycleCallbacks);
        }
    }
}