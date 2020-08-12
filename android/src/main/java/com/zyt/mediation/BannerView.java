package com.zyt.mediation;

import android.content.Context;
import android.graphics.Color;
import android.os.Handler;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import mobi.android.BannerAd;
import mobi.android.ZYTMediationSDK;

/**
 * @author ling.zhang
 * date 2020/8/10 7:35 PM
 * description:
 */
public class BannerView implements PlatformView, Constants {
    private Map<String, Object> argMap;
    private RelativeLayout adContainer;
    private int viewId;
    private MethodChannel adMethodChannel;
    private BinaryMessenger binaryMessenger;

    public BannerView(Context context, int viewId, BinaryMessenger binaryMessenger, Map<String, Object> argMap) {
        this.argMap = argMap;
        this.viewId = viewId;
        this.binaryMessenger = binaryMessenger;
        adContainer = new RelativeLayout(context);
    }

    @Override
    public View getView() {
        final Object adUnitAd = argMap.get(A_AD_UNIT_ID);
        if (adUnitAd instanceof String && !TextUtils.isEmpty((CharSequence) adUnitAd)) {
//            BannerPlugin.show((String) adUnitAd, adContainer);
            loadBanner((String) adUnitAd);
        }
        return adContainer;
    }

    private void loadBanner(String adUnitId) {
        adMethodChannel = new MethodChannel(binaryMessenger, V_BANNER + "/" + viewId);
        BannerAd.loadAd(adUnitId, new BannerAdListener() {
            @Override
            public void onAdLoaded(String s, BannerAdResponse bannerAdResponse) {
                bannerAdResponse.show(adContainer);
//                adMethodChannel.invokeMethod(C_ON_LAYOUT_CHANGE, new MapBuilder<String, Float>()
//                        .put(WIDTH, adContainer.getMeasuredWidth())
//                        .put(HEIGHT, adContainer.getMeasuredHeight())
//                        .build());

            }

            @Override
            public void onAdClicked(String s) {

            }

            @Override
            public void onAdClosed(String s) {

            }

            @Override
            public void onError(String s, String s1) {

            }
        });
    }

    @Override
    public void dispose() {
        if (adContainer != null) {
            adContainer.setVisibility(View.GONE);
            adContainer = null;
        }
    }
}
