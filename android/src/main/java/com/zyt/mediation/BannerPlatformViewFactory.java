package com.zyt.mediation;

import android.content.Context;
import android.util.Log;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;


/**
 * @author ling.zhang
 * date 2020/8/10 6:59 PM
 * description:
 */
public class BannerPlatformViewFactory extends PlatformViewFactory {
    private BinaryMessenger binaryMessenger;

    /**
     * @param createArgsCodec the codec used to decode the args parameter of {@link #create}.
     */
    public BannerPlatformViewFactory(MessageCodec<Object> createArgsCodec, BinaryMessenger binaryMessenger) {
        super(createArgsCodec);
        this.binaryMessenger = binaryMessenger;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        if (args instanceof Map) {
            return new BannerView(context, viewId, binaryMessenger, (Map<String, Object>) args);
        }
        return null;
    }
}
