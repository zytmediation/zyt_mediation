package com.zyt.mediation;

import android.content.Context;
import android.graphics.Color;
import android.os.Handler;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
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
    private RelativeLayout adContainer;
    private int viewId;
    private MethodChannel adMethodChannel;
    private BinaryMessenger binaryMessenger;

    public BannerView(Context context, int viewId, BinaryMessenger binaryMessenger, Map<String, Object> argMap) {
        this.argMap = argMap;
        this.viewId = viewId;
        this.binaryMessenger = binaryMessenger;
        adContainer = new RelativeLayout(context);
        adContainer.setBackgroundColor(Color.BLUE);
    }

    Handler handler = new Handler();

    @Override
    public View getView() {
        final Object adUnitAd = argMap.get(A_AD_UNIT_ID);
        if (adUnitAd instanceof String && !TextUtils.isEmpty((CharSequence) adUnitAd)) {
//            BannerPlugin.show((String) adUnitAd, adContainer);
            initChannel();
            handler.removeCallbacksAndMessages(null);
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    loadBanner((String) adUnitAd);
                }
            }, 15000);
        }
        return adContainer;
    }

    private void initChannel() {
        adMethodChannel = new MethodChannel(binaryMessenger, P_BANNER + "/" + viewId);
    }

    private void loadBanner(final String adUnitId) {
        Log.d("flutter log", "load banner:" + adUnitId);
        BannerAd.loadAd(adUnitId, new BannerAdListener() {
            @Override
            public void onAdLoaded(String s, BannerAdResponse bannerAdResponse) {
//                bannerAdResponse.show(adContainer);
                final LinearLayout linearLayout = new LinearLayout(adContainer.getContext());
                linearLayout.setGravity(Gravity.CENTER);
                bannerAdResponse.show(linearLayout);
                linearLayout.measure(View.MeasureSpec.makeMeasureSpec(1080, View.MeasureSpec.AT_MOST),
                        View.MeasureSpec.makeMeasureSpec(1920, View.MeasureSpec.AT_MOST));
                adMethodChannel.invokeMethod(C_ON_LAYOUT_CHANGE, new MapBuilder<String, Integer>()
                        .put(WIDTH, linearLayout.getMeasuredWidth())
                        .put(HEIGHT, linearLayout.getMeasuredHeight())
                        .build());

                adContainer.removeAllViews();
                adContainer.addView(linearLayout);
                handler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        loadBanner(adUnitId);
                    }
                }, 10000);
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
                handler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        loadBanner(adUnitId);
                    }
                }, 3000);
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
            adContainer = null;
        }
    }
}
