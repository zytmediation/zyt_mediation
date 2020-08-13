package com.zyt.mediation;

import android.text.TextUtils;
import android.util.Log;
import android.view.ViewGroup;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import mobi.android.BannerAd;

/**
 * @author ling.zhang
 * date 2020/8/11 10:50 AM
 * description:
 */
public class BannerPlugin extends BasePlugin {
    private BinaryMessenger binaryMessenger;
    private static Map<String, BannerAdResponse> bannerAdResponseMap = new HashMap<>();

    public BannerPlugin() {
    }

    public BannerPlugin(BinaryMessenger binaryMessenger) {
        this.binaryMessenger = binaryMessenger;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case M_BANNER_LOAD_AD:
                load(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    public void load(MethodCall call, MethodChannel.Result result) {
        String adUnitId = call.argument(A_AD_UNIT_ID);
        Integer channelId = call.argument(A_CHANNEL_ID);
        if (TextUtils.isEmpty(adUnitId)) {
            result.error("error", "adUnitId is empty", null);
            return;
        }

        MethodChannel _adChannel = null;
        if (channelId != null && binaryMessenger != null) {
            _adChannel = new MethodChannel(binaryMessenger, P_BANNER + channelId);
        }
        final MethodChannel final_adChannel = _adChannel;
        BannerAd.loadAd(adUnitId, new BannerAdListener() {
            @Override
            public void onAdLoaded(String s, BannerAdResponse bannerAdResponse) {
                bannerAdResponseMap.put(s, bannerAdResponse);
                if (final_adChannel != null) {
                    final_adChannel.invokeMethod(C_BANNER_ON_AD_LOADED, MapBuilder.of(A_AD_UNIT_ID, s));
                }
            }

            @Override
            public void onAdClicked(String s) {
                if (final_adChannel != null) {
                    final_adChannel.invokeMethod(C_BANNER_ON_AD_CLICK, MapBuilder.of(A_AD_UNIT_ID, s));
                }
            }

            @Override
            public void onAdClosed(String s) {
                if (final_adChannel != null) {
                    final_adChannel.invokeMethod(C_BANNER_ON_AD_CLOSE, MapBuilder.of(A_AD_UNIT_ID, s));
                }
            }

            @Override
            public void onError(String s, String s1) {
                if (final_adChannel != null) {
                    Map<String, String> argMap = new MapBuilder<String, String>()
                            .put(A_AD_UNIT_ID, s)
                            .put(A_ERR_MSG, s1)
                            .build();
                    final_adChannel.invokeMethod(C_BANNER_ON_ERROR, argMap);
                }
            }
        });
        result.success(null);
    }

    public static void show(String adUnitId, ViewGroup container) {
        BannerAdResponse bannerAdResponse = bannerAdResponseMap.get(adUnitId);
        if (bannerAdResponse != null && container != null) {
            bannerAdResponseMap.remove(bannerAdResponse);
            bannerAdResponse.show(container);
            Log.d("flutter log", "==================show banner");
        }
    }
}