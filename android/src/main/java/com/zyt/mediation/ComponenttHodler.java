package com.zyt.mediation;

import android.app.Activity;

/**
 * @author ling.zhang
 * date 2020/10/27 2:21 PM
 * description:
 */
public class ComponenttHodler {
    private static Activity activity;

    public static Activity getActivity() {
        return activity;
    }

    public static void setActivity(Activity activity) {
        ComponenttHodler.activity = activity;
    }
}
