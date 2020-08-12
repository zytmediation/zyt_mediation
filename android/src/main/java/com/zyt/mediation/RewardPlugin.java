package com.zyt.mediation;

import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import mobi.android.RewardAd;

/**
 * @author ling.zhang
 * date 2020/8/6 3:27 PM
 * description:
 */
public class RewardPlugin extends BasePlugin {
    private BinaryMessenger binaryMessenger;

    public RewardPlugin(BinaryMessenger binaryMessenger) {
        this.binaryMessenger = binaryMessenger;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case M_REWARD_LOAD_AD:
                loadAd(call, result);
                break;
            case M_REWARD_SHOW:
                show(call, result);
                break;
            case M_REWARD_IS_READY:
                isReady(call, result);
                break;
            default:

                result.notImplemented();
        }
    }

    public void loadAd(MethodCall call, MethodChannel.Result result) {
        String adUnitId = call.argument(A_AD_UNIT_ID);
        Integer channelId = call.argument(A_CHANNEL_ID);
        if (TextUtils.isEmpty(adUnitId)) {
            result.error("error", "adUnitId is empty", null);
            return;
        }

        MethodChannel _adChannel = null;
        if (channelId != null && binaryMessenger != null) {
            _adChannel = new MethodChannel(binaryMessenger, P_REWARD + channelId);
        }
        final MethodChannel final_adChannel = _adChannel;
        RewardAd.loadAd(adUnitId, new RewardAdLoadListener() {
            @Override
            public void onLoaded(String s, RewardAdResponse rewardAdResponse) {
                if (final_adChannel != null) {
                    final_adChannel.invokeMethod(C_REWARD_ON_LOADED, MapBuilder.of(A_AD_UNIT_ID, s));
                }
            }

            @Override
            public void onError(String s, String s1) {
                if (final_adChannel != null) {
                    Map<String, String> argMap = new MapBuilder<String, String>()
                            .put(A_AD_UNIT_ID, s)
                            .put(A_ERR_MSG, s1)
                            .build();
                    final_adChannel.invokeMethod(C_REWARD_ON_ERROR, argMap);
                }
            }
        });
        result.success(null);
    }

    public void isReady(MethodCall call, MethodChannel.Result result) {
        String adUnitId = call.argument(A_AD_UNIT_ID);
        if (!TextUtils.isEmpty(adUnitId)) {
            result.success(RewardAd.isReady(adUnitId));
        } else {
            result.success(false);
        }
    }

    public void show(MethodCall call, MethodChannel.Result result) {
        String adUnitId = call.argument(A_AD_UNIT_ID);
        Integer channelId = call.argument(A_CHANNEL_ID);
        if (TextUtils.isEmpty(adUnitId)) {
            result.error("error", "adUnitId is empty", null);
            return;
        }

        MethodChannel _adChannel = null;
        if (channelId != null && binaryMessenger != null) {
            _adChannel = new MethodChannel(binaryMessenger, P_REWARD + channelId);
        }
        final MethodChannel final_adChannel = _adChannel;
        RewardAd.show(adUnitId, new RewardAdShowListener() {
            @Override
            public void onADShow(String s) {
                if (final_adChannel != null) {
                    final_adChannel.invokeMethod(C_REWARD_ON_AD_SHOW, MapBuilder.of(A_AD_UNIT_ID, s));
                }
            }

            @Override
            public void onADClick(String s) {
                if (final_adChannel != null) {
                    final_adChannel.invokeMethod(C_REWARD_ON_AD_CLICK, MapBuilder.of(A_AD_UNIT_ID, s));
                }
            }

            @Override
            public void onADFinish(String s, boolean b) {
                if (final_adChannel != null) {
                    final_adChannel.invokeMethod(C_REWARD_ON_AD_FINISH,
                            new MapBuilder<>()
                                    .put(A_AD_UNIT_ID, s)
                                    .put(A_REWARD, b).build());
                }
            }
        });
        result.success(null);
    }
}