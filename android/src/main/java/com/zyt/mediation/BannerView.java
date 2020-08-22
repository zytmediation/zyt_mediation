package com.zyt.mediation;

import android.content.Context;
import android.graphics.Color;
import android.text.Layout;
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
import mobi.android.BannerAd;

/**
 * @author ling.zhang
 * date 2020/8/10 7:35 PM
 * description:
 */
public class BannerView implements PlatformView, Constants {
    private Map<String, Object> argMap;
    private LinearLayout adContainer;
    private int viewId;
    private MethodChannel adMethodChannel;
    private BinaryMessenger binaryMessenger;
    private boolean isShow = false;

    public BannerView(Context context, int viewId, BinaryMessenger binaryMessenger, Map<String, Object> argMap) {
        this.argMap = argMap;
        this.viewId = viewId;
        this.binaryMessenger = binaryMessenger;
        adContainer = new LinearLayout(context);
        adContainer.setGravity(Gravity.CENTER);
        adContainer.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
    }

    @Override
    public View getView() {
        final Object adUnitAd = argMap.get(A_AD_UNIT_ID);
        if (adUnitAd instanceof String && !TextUtils.isEmpty((CharSequence) adUnitAd) && !isShow && adMethodChannel == null) {
            initChannel();
            loadBanner((String) adUnitAd);
        }
        return adContainer;
    }

    private void initChannel() {
        adMethodChannel = new MethodChannel(binaryMessenger, P_BANNER + "/" + viewId);
    }

    private void loadBanner(final String adUnitId) {
        BannerAd.loadAd(adUnitId, new BannerAdListener() {
            @Override
            public void onAdLoaded(String s, BannerAdResponse bannerAdResponse) {
                isShow = true;
                adContainer.removeAllViews();
                bannerAdResponse.show(adContainer);
                adMethodChannel.invokeMethod(C_BANNER_ON_AD_LOADED, MapBuilder.of(A_AD_UNIT_ID, s));
            }

            @Override
            public void onAdClicked(String s) {
                adMethodChannel.invokeMethod(C_BANNER_ON_AD_CLICK, MapBuilder.of(A_AD_UNIT_ID, s));
            }

            @Override
            public void onAdClosed(String s) {
                adMethodChannel.invokeMethod(C_BANNER_ON_AD_CLOSE, MapBuilder.of(A_AD_UNIT_ID, s));
            }

            @Override
            public void onError(String s, String s1) {
                adMethodChannel.invokeMethod(C_BANNER_ON_ERROR,
                        new MapBuilder<String, String>()
                                .put(A_AD_UNIT_ID, s)
                                .put(A_ERR_MSG, s1)
                                .build());
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
