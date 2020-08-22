package com.zyt.mediation;

import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;

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

/**
 * MediationFlutterPlugin
 */
public class MediationFlutterPlugin extends BasePlugin implements FlutterPlugin, ActivityAware {
    private MethodChannel channel;
    private Context mContext;

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

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        DartExecutor dartExecutor = flutterPluginBinding.getFlutterEngine().getDartExecutor();
        mContext = flutterPluginBinding.getApplicationContext();

//        mContext.startActivity(new Intent(mContext, MediationActivity.class));

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
    }

    /**
     * 兼容1.12以下版本代码
     */
    public static void registerWith(Registrar registrar) {
        ComponentHolder.setUnity(true);
        ComponentHolder.setUnityActivity(registrar.activity());
        BinaryMessenger messenger = registrar.messenger();
        final MethodChannel channel = new MethodChannel(messenger, P_MEDIATION_FLUTTER);
        channel.setMethodCallHandler(new MediationFlutterPlugin(channel, registrar.context()));

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
}