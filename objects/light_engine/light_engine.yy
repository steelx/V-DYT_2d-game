{
  "$GMObject":"",
  "%Name":"light_engine",
  "eventList":[
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":8,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":0,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":2,"eventType":3,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":0,"eventType":12,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":72,"eventType":8,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":4,"eventType":7,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":10,"eventType":7,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":11,"eventType":7,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":12,"eventType":7,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":13,"eventType":7,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":10,"eventType":2,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":14,"eventType":7,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":5,"eventType":7,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
    {"$GMEvent":"v1","%Name":"","collisionObjectId":null,"eventNum":15,"eventType":7,"isDnD":false,"name":"","resourceType":"GMEvent","resourceVersion":"2.0",},
  ],
  "managed":true,
  "name":"light_engine",
  "overriddenProperties":[],
  "parent":{
    "name":"Light Engine",
    "path":"folders/Light Engine.yy",
  },
  "parentObjectId":null,
  "persistent":false,
  "physicsAngularDamping":0.1,
  "physicsDensity":0.5,
  "physicsFriction":0.2,
  "physicsGroup":1,
  "physicsKinematic":false,
  "physicsLinearDamping":0.1,
  "physicsObject":false,
  "physicsRestitution":0.1,
  "physicsSensor":false,
  "physicsShape":1,
  "physicsShapePoints":[],
  "physicsStartAwake":true,
  "properties":[
    {"$GMObjectProperty":"v1","%Name":"bloom_amount","filters":[],"listItems":[],"multiselect":false,"name":"bloom_amount","rangeEnabled":true,"rangeMax":5.0,"rangeMin":1.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"3","varType":1,},
    {"$GMObjectProperty":"v1","%Name":"bloom_intensity","filters":[],"listItems":[],"multiselect":false,"name":"bloom_intensity","rangeEnabled":true,"rangeMax":1.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0.25","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"ambient_direction","filters":[],"listItems":[],"multiselect":false,"name":"ambient_direction","rangeEnabled":true,"rangeMax":359.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"315","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"ambient_elevation","filters":[],"listItems":[],"multiselect":false,"name":"ambient_elevation","rangeEnabled":true,"rangeMax":90.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"45","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"ambient_intensity","filters":[],"listItems":[],"multiselect":false,"name":"ambient_intensity","rangeEnabled":true,"rangeMax":1.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0.05","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"ambient_color","filters":[],"listItems":[],"multiselect":false,"name":"ambient_color","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"$FFE6FFBA","varType":7,},
    {"$GMObjectProperty":"v1","%Name":"layers_background","filters":[],"listItems":[],"multiselect":false,"name":"layers_background","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"[\"Background\", \"Background\"]","varType":4,},
    {"$GMObjectProperty":"v1","%Name":"layers_normal","filters":[],"listItems":[],"multiselect":false,"name":"layers_normal","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"[\"normal_begin\", \"normal_end\"]","varType":4,},
    {"$GMObjectProperty":"v1","%Name":"layers_material","filters":[],"listItems":[],"multiselect":false,"name":"layers_material","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"[\"material_begin\", \"material_end\"]","varType":4,},
    {"$GMObjectProperty":"v1","%Name":"layers_normal_emissive","filters":[],"listItems":[],"multiselect":false,"name":"layers_normal_emissive","rangeEnabled":false,"rangeMax":1.0,"rangeMin":-1.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"LAYER_NO_EMISSIVE","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"layers_material_occlude","filters":[],"listItems":[],"multiselect":false,"name":"layers_material_occlude","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"True","varType":3,},
    {"$GMObjectProperty":"v1","%Name":"shadow_divisions_x","filters":[],"listItems":[],"multiselect":false,"name":"shadow_divisions_x","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"1","varType":1,},
    {"$GMObjectProperty":"v1","%Name":"shadow_divisions_y","filters":[],"listItems":[],"multiselect":false,"name":"shadow_divisions_y","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"1","varType":1,},
    {"$GMObjectProperty":"v1","%Name":"layers_normal_front","filters":[],"listItems":[],"multiselect":false,"name":"layers_normal_front","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"[\"normal_begin_front\", \"normal_end_front\"]","varType":4,},
    {"$GMObjectProperty":"v1","%Name":"layers_material_front","filters":[],"listItems":[],"multiselect":false,"name":"layers_material_front","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"[\"material_begin_front\", \"material_end_front\"]","varType":4,},
    {"$GMObjectProperty":"v1","%Name":"layers_normal_front_emissive","filters":[],"listItems":[],"multiselect":false,"name":"layers_normal_front_emissive","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"LAYER_NO_EMISSIVE","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"layers_material_front_occlude","filters":[],"listItems":[],"multiselect":false,"name":"layers_material_front_occlude","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0","varType":3,},
    {"$GMObjectProperty":"v1","%Name":"shadow_atlas_size","filters":[],"listItems":[
        "1024",
        "2048",
        "4096",
        "8192",
      ],"multiselect":false,"name":"shadow_atlas_size","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"2048","varType":6,},
    {"$GMObjectProperty":"v1","%Name":"shadow_map_size","filters":[],"listItems":[
        "256",
        "512",
        "1024",
        "2048",
        "4096",
      ],"multiselect":false,"name":"shadow_map_size","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"1024","varType":6,},
    {"$GMObjectProperty":"v1","%Name":"shadow_type","filters":[],"listItems":[
        "LE_SHADOW_TYPE_SOFT",
        "LE_SHADOW_TYPE_HARD",
      ],"multiselect":false,"name":"shadow_type","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"LE_SHADOW_TYPE_SOFT","varType":6,},
    {"$GMObjectProperty":"v1","%Name":"enable_lighting_buffer","filters":[],"listItems":[],"multiselect":false,"name":"enable_lighting_buffer","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"False","varType":3,},
    {"$GMObjectProperty":"v1","%Name":"shadow_blur_amount","filters":[],"listItems":[],"multiselect":false,"name":"shadow_blur_amount","rangeEnabled":true,"rangeMax":10.0,"rangeMin":3.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"3","varType":1,},
    {"$GMObjectProperty":"v1","%Name":"object_occlusion","filters":[],"listItems":[],"multiselect":false,"name":"object_occlusion","rangeEnabled":false,"rangeMax":10.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"True","varType":3,},
    {"$GMObjectProperty":"v1","%Name":"shadow_opacity","filters":[],"listItems":[],"multiselect":false,"name":"shadow_opacity","rangeEnabled":true,"rangeMax":1.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"1","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"dof_near","filters":[],"listItems":[],"multiselect":false,"name":"dof_near","rangeEnabled":true,"rangeMax":1.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"1","varType":0,},
    {"$GMObjectProperty":"v1","%Name":"dof_far","filters":[],"listItems":[],"multiselect":false,"name":"dof_far","rangeEnabled":true,"rangeMax":1.0,"rangeMin":0.0,"resourceType":"GMObjectProperty","resourceVersion":"2.0","value":"0","varType":0,},
  ],
  "resourceType":"GMObject",
  "resourceVersion":"2.0",
  "solid":false,
  "spriteId":{
    "name":"spr_eclipse",
    "path":"sprites/spr_eclipse/spr_eclipse.yy",
  },
  "spriteMaskId":null,
  "visible":true,
}