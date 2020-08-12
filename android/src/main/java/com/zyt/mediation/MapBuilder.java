package com.zyt.mediation;

import java.util.HashMap;
import java.util.Map;

/**
 * @author ling.zhang
 * date 2020/8/8 3:30 PM
 * description:
 */
public class MapBuilder<K, V> {
    private Map<K, V> map;

    public MapBuilder() {
        this.map = new HashMap<>();
    }

    public MapBuilder<K, V> put(K key, V value) {
        map.put(key, value);
        return this;
    }

    public Map<K, V> build() {
        return map;
    }

    public static <K, V> Map<K, V> of(final K key, final V value) {
        return new HashMap<K, V>() {
            {
                put(key, value);
            }
        };
    }
}
