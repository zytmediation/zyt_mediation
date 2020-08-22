package com.zyt.mediation;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import mobi.android.NativeAd;

/**
 * @author ling.zhang
 * date 2020/8/10 7:36 PM
 * description:
 */
public class NativeView implements PlatformView, Constants {
    private Map<String, Object> argMap;
    private RelativeLayout adContainer;
    private int viewId;
    private MethodChannel adMethodChannel;
    private BinaryMessenger binaryMessenger;
    private int lastWidth;
    private int lastHeight;
    private boolean isShow = false;
    private ViewTreeObserver.OnGlobalLayoutListener onGlobalLayoutListener = new ViewTreeObserver.OnGlobalLayoutListener() {
        @Override
        public void onGlobalLayout() {
            if (adMethodChannel != null) {
                int measuredWidth = adContainer.getMeasuredWidth();
                int measuredHeight = adContainer.getMeasuredHeight();
                if ((measuredWidth != lastWidth || measuredHeight != lastHeight) && measuredWidth > 10 && measuredHeight > 10) {
                    lastWidth = measuredWidth;
                    lastHeight = measuredHeight;
                    adMethodChannel.invokeMethod(C_ON_LAYOUT_CHANGE, new MapBuilder<String, Integer>()
                            .put(WIDTH, measuredWidth)
                            .put(HEIGHT, measuredHeight)
                            .build());
                }
            }
        }
    };

    public NativeView(Context context, int viewId, BinaryMessenger binaryMessenger, Map<String, Object> argMap) {
        this.argMap = argMap;
        this.viewId = viewId;
        this.binaryMessenger = binaryMessenger;
        adContainer = new RelativeLayout(context);
        adContainer.setGravity(Gravity.CENTER);
        adContainer.setLayoutParams(new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        adContainer.getViewTreeObserver().addOnGlobalLayoutListener(onGlobalLayoutListener);
    }

    @Override
    public View getView() {
        final Object adUnitAd = argMap.get(A_AD_UNIT_ID);
        if (adUnitAd instanceof String && !TextUtils.isEmpty((CharSequence) adUnitAd) && !isShow && adMethodChannel == null) {
            initChannel();
            loadNative((String) adUnitAd);
        }
        return adContainer;
    }

    private void initChannel() {
        adMethodChannel = new MethodChannel(binaryMessenger, P_NATIVE + "/" + viewId);
    }

    private void loadNative(final String adUnitId) {
        NativeAd.loadAd(adUnitId, AdParam.create().setSize(AdParam.FULL_WIDTH, AdParam.AUTO_HEIGHT).build(), new NativerAdListener() {
            @Override
            public void onError(String s, String s1) {
                adMethodChannel.invokeMethod(C_NATIVE_ON_ERROR,
                        new MapBuilder<String, String>()
                                .put(A_AD_UNIT_ID, s)
                                .put(A_ERR_MSG, s1)
                                .build());
            }

            @Override
            public void onAdClosed(String s) {
                adMethodChannel.invokeMethod(C_NATIVE_ON_AD_CLOSE, MapBuilder.of(A_AD_UNIT_ID, s));
            }

            @Override
            public void onAdClicked(String s) {
                adMethodChannel.invokeMethod(C_NATIVE_ON_AD_CLICK, MapBuilder.of(A_AD_UNIT_ID, s));
            }

            @Override
            public void onAdLoaded(String s, NativerAdResponse nativerAdResponse) {
                isShow = true;
                adContainer.getViewTreeObserver().removeOnGlobalLayoutListener(onGlobalLayoutListener);
                adContainer.getViewTreeObserver().addOnGlobalLayoutListener(onGlobalLayoutListener);
                adContainer.removeAllViews();
                nativerAdResponse.show(adContainer);
                adMethodChannel.invokeMethod(C_NATIVE_ON_AD_LOADED, MapBuilder.of(A_AD_UNIT_ID, s));
            }
        });
    }

    @Override
    public void dispose() {
        if (adContainer != null) {
            adContainer.setVisibility(View.GONE);
        }
    }
}
