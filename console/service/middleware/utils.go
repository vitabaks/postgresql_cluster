package middleware

import "reflect"

func replaceFields(data map[string]interface{}, replacements map[string]string) {
	for key, val := range data {
		if replacement, ok := replacements[key]; ok {
			data[key] = replacement
		} else {
			valReflect := reflect.ValueOf(val)
			switch valReflect.Kind() {
			case reflect.Map:
				if innerMap, ok := val.(map[string]interface{}); ok {
					replaceFields(innerMap, replacements)
				}
			case reflect.Slice:
				for j := 0; j < valReflect.Len(); j++ {
					elemVal := valReflect.Index(j)
					if innerElemMap, ok := elemVal.Interface().(map[string]interface{}); ok {
						replaceFields(innerElemMap, replacements)
					}
				}
			case reflect.Ptr:
				if !valReflect.IsNil() {
					elem := valReflect.Elem().Interface()
					if innerMap, ok := elem.(map[string]interface{}); ok {
						replaceFields(innerMap, replacements)
					}
				}
			}
		}
	}
}
