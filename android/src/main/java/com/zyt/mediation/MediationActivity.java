package com.zyt.mediation;

import android.app.Activity;
import android.os.Bundle;

/**
 * @author ling.zhang
 * date 2020/8/11 5:58 PM
 * description:
 */
class MediationActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout_dsp_webview);
    }

    @Override
    protected void onResume() {
        super.onResume();
        finish();
    }
}
