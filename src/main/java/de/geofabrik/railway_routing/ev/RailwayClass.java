package de.geofabrik.railway_routing.ev;

import com.graphhopper.routing.ev.EnumEncodedValue;
import com.graphhopper.util.Helper;

/**
 * This enum defines the railway class of an edge. It maps the railway=* key of OSM to an enum. All edges that do not fit get OTHER as value.
 */
public enum RailwayClass {
    OTHER, RAIL, SUBWAY, TRAM, LIGHT_RAIL, FUNICULAR, CONSTRUCTION, MONORAIL, PROPOSED;

    public static final String KEY = "railway_class";

    public static EnumEncodedValue<RailwayClass> create() {
        return new EnumEncodedValue<>(RailwayClass.KEY, RailwayClass.class);
    }

    @Override
    public String toString() {
        return Helper.toLowerCase(super.toString());
    }

    public static RailwayClass find(String name) {
        if (name == null || name.isEmpty())
            return OTHER;
        try {
            return RailwayClass.valueOf(Helper.toUpperCase(name));
        } catch (IllegalArgumentException ex) {
            return OTHER;
        }
    }
}
