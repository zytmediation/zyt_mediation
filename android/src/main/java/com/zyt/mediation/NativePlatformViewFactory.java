package com.zyt.mediation;

import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * @author ling.zhang
 * date 2020/8/18 6:35 PM
 * description:
 */
class NativePlatformViewFactory extends PlatformViewFactory {
    private BinaryMessenger binaryMessenger;

    /**
     * @param createArgsCodec the codec used to decode the args parameter of {@link #create}.
     */
    public NativePlatformViewFactory(MessageCodec<Object> createArgsCodec, BinaryMessenger binaryMessenger) {
        super(createArgsCodec);
        this.binaryMessenger = binaryMessenger;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        if (args instanceof Map) {
            return new NativeView(context, viewId, binaryMessenger, (Map<String, Object>) args);
        }
        return null;
    }
}
