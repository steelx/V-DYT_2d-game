{
  "$GMSequence":"",
  "%Name":"seq_guardian_attack",
  "autoRecord":true,
  "backdropHeight":180,
  "backdropImageOpacity":0.5,
  "backdropImagePath":"",
  "backdropWidth":240,
  "backdropXOffset":0.0,
  "backdropYOffset":0.0,
  "events":{
    "$KeyframeStore<MessageEventKeyframe>":"",
    "Keyframes":[],
    "resourceType":"KeyframeStore<MessageEventKeyframe>",
    "resourceVersion":"2.0",
  },
  "eventStubScript":null,
  "eventToFunction":{},
  "length":72.0,
  "lockOrigin":false,
  "moments":{
    "$KeyframeStore<MomentsEventKeyframe>":"",
    "Keyframes":[
      {"$Keyframe<MomentsEventKeyframe>":"","Channels":{
          "0":{"$MomentsEventKeyframe":"","Events":[
              "guardian_smash_moment",
            ],"resourceType":"MomentsEventKeyframe","resourceVersion":"2.0",},
        },"Disabled":false,"id":"816d66a7-7fc7-4556-9303-162bbe688971","IsCreationKey":false,"Key":44.0,"Length":1.0,"resourceType":"Keyframe<MomentsEventKeyframe>","resourceVersion":"2.0","Stretch":false,},
    ],
    "resourceType":"KeyframeStore<MomentsEventKeyframe>",
    "resourceVersion":"2.0",
  },
  "name":"seq_guardian_attack",
  "parent":{
    "name":"guardian",
    "path":"folders/Objects/Characters/Enemies/guardian.yy",
  },
  "playback":0,
  "playbackSpeed":60.0,
  "playbackSpeedType":0,
  "resourceType":"GMSequence",
  "resourceVersion":"2.0",
  "showBackdrop":true,
  "showBackdropImage":false,
  "spriteId":null,
  "timeUnits":1,
  "tracks":[
    {"$GMGraphicTrack":"","%Name":"spr_hit_1","builtinName":0,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"$KeyframeStore<AssetSpriteKeyframe>":"","Keyframes":[
          {"$Keyframe<AssetSpriteKeyframe>":"","Channels":{
              "0":{"$AssetSpriteKeyframe":"","Id":{"name":"spr_sparks_hit_1","path":"sprites/spr_sparks_hit_1/spr_sparks_hit_1.yy",},"resourceType":"AssetSpriteKeyframe","resourceVersion":"2.0",},
            },"Disabled":false,"id":"ed11be72-0c0e-418b-a9bd-510d3be463a2","IsCreationKey":false,"Key":30.0,"Length":25.0,"resourceType":"Keyframe<AssetSpriteKeyframe>","resourceVersion":"2.0","Stretch":false,},
        ],"resourceType":"KeyframeStore<AssetSpriteKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"spr_hit_1","resourceType":"GMGraphicTrack","resourceVersion":"2.0","trackColour":4282970721,"tracks":[
        {"$GMRealTrack":"","%Name":"origin","builtinName":16,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":true,"keyframes":{"$KeyframeStore<RealKeyframe>":"","Keyframes":[
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.0,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                  "1":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.0,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"66187328-7499-4cf0-b88d-f6f743110b90","IsCreationKey":true,"Key":33.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
            ],"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"origin","resourceType":"GMRealTrack","resourceVersion":"2.0","trackColour":4282970721,"tracks":[],"traits":0,},
        {"$GMRealTrack":"","%Name":"position","builtinName":14,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"$KeyframeStore<RealKeyframe>":"","Keyframes":[
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":50.107803,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                  "1":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":3.8146973E-06,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"35fd66d2-bff3-4b12-b24b-acd5fdc3de1b","IsCreationKey":false,"Key":30.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":54.0,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                  "1":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":6.000004,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"9102090a-e4a3-47af-90ba-d54c37dbbf15","IsCreationKey":false,"Key":34.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
            ],"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"position","resourceType":"GMRealTrack","resourceVersion":"2.0","trackColour":4282970721,"tracks":[],"traits":0,},
        {"$GMRealTrack":"","%Name":"rotation","builtinName":8,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"$KeyframeStore<RealKeyframe>":"","Keyframes":[
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":-90.0,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"c4703e93-4ad5-4e66-8d8d-d0dc80263db3","IsCreationKey":false,"Key":30.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
            ],"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"rotation","resourceType":"GMRealTrack","resourceVersion":"2.0","trackColour":4282970721,"tracks":[],"traits":0,},
        {"$GMRealTrack":"","%Name":"scale","builtinName":15,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":true,"keyframes":{"$KeyframeStore<RealKeyframe>":"","Keyframes":[
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":1.0,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                  "1":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":1.0,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"58cf86e5-cbe8-44ca-b2a6-1ff7dac511b6","IsCreationKey":true,"Key":33.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
            ],"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"scale","resourceType":"GMRealTrack","resourceVersion":"2.0","trackColour":4282970721,"tracks":[],"traits":0,},
      ],"traits":0,},
    {"$GMAudioTrack":"","%Name":"snd_guardian_attack","builtinName":0,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"$KeyframeStore<AudioKeyframe>":"","Keyframes":[
          {"$Keyframe<AudioKeyframe>":"","Channels":{
              "0":{"$AudioKeyframe":"","Id":{"name":"snd_guardian_attack","path":"sounds/snd_guardian_attack/snd_guardian_attack.yy",},"Mode":0,"resourceType":"AudioKeyframe","resourceVersion":"2.0",},
            },"Disabled":false,"id":"13bff141-a1ed-4b4b-a49b-e427e067544d","IsCreationKey":false,"Key":30.0,"Length":40.0,"resourceType":"Keyframe<AudioKeyframe>","resourceVersion":"2.0","Stretch":false,},
        ],"resourceType":"KeyframeStore<AudioKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"snd_guardian_attack","resourceType":"GMAudioTrack","resourceVersion":"2.0","trackColour":4282970721,"tracks":[
        {"$GMRealTrack":"","%Name":"position","builtinName":14,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"$KeyframeStore<RealKeyframe>":"","Keyframes":[
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":46.201233,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                  "1":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":4.567169,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"efa2f68c-d50d-4135-9bda-902525a268e6","IsCreationKey":false,"Key":30.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
            ],"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"position","resourceType":"GMRealTrack","resourceVersion":"2.0","trackColour":4282970721,"tracks":[],"traits":0,},
        {"$GMRealTrack":"","%Name":"rotation","builtinName":8,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":true,"keyframes":{"$KeyframeStore<RealKeyframe>":"","Keyframes":[
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.0,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"963f6bac-c971-43a3-a6b4-7b087ca88f6c","IsCreationKey":true,"Key":30.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
            ],"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"rotation","resourceType":"GMRealTrack","resourceVersion":"2.0","trackColour":4282970721,"tracks":[],"traits":0,},
      ],"traits":0,},
    {"$GMInstanceTrack":"","%Name":"obj_guardian_hitbox","builtinName":0,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"$KeyframeStore<AssetInstanceKeyframe>":"","Keyframes":[
          {"$Keyframe<AssetInstanceKeyframe>":"","Channels":{
              "0":{"$AssetInstanceKeyframe":"","Id":{"name":"obj_guardian_hitbox","path":"objects/obj_guardian_hitbox/obj_guardian_hitbox.yy",},"resourceType":"AssetInstanceKeyframe","resourceVersion":"2.0",},
            },"Disabled":false,"id":"24421cde-0865-498b-b29a-87864c551b00","IsCreationKey":false,"Key":30.0,"Length":24.0,"resourceType":"Keyframe<AssetInstanceKeyframe>","resourceVersion":"2.0","Stretch":false,},
        ],"resourceType":"KeyframeStore<AssetInstanceKeyframe>","resourceVersion":"2.0",},"modifiers":[
        {"$InvisibleModifier":"","resourceType":"InvisibleModifier","resourceVersion":"2.0",},
      ],"name":"obj_guardian_hitbox","resourceType":"GMInstanceTrack","resourceVersion":"2.0","trackColour":4282936306,"tracks":[
        {"$GMRealTrack":"","%Name":"origin","builtinName":16,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":true,"keyframes":{"$KeyframeStore<RealKeyframe>":"","Keyframes":[
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.0,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                  "1":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.0,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"02dbe0a9-9893-4a64-a911-67b33ee73aa5","IsCreationKey":true,"Key":30.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
            ],"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"2.0",},"modifiers":[
            {"$InvisibleModifier":"","resourceType":"InvisibleModifier","resourceVersion":"2.0",},
          ],"name":"origin","resourceType":"GMRealTrack","resourceVersion":"2.0","trackColour":4282936306,"tracks":[],"traits":0,},
        {"$GMRealTrack":"","%Name":"position","builtinName":14,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"$KeyframeStore<RealKeyframe>":"","Keyframes":[
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":46.107803,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                  "1":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":-9.952557,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"915defc6-a35a-4103-b4e2-be46167d8a8f","IsCreationKey":false,"Key":30.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":47.453957,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                  "1":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":-9.952557,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"cb1792f2-1e66-401e-bdf7-9537e00c8758","IsCreationKey":false,"Key":32.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":43.943916,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                  "1":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":-8.952557,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"83f2b67b-5d66-4049-8548-020d3b7de546","IsCreationKey":false,"Key":43.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":31.607803,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                  "1":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":-8.952557,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"cfecfea2-1336-4e38-9fe6-fad213be8109","IsCreationKey":false,"Key":53.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
            ],"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"2.0",},"modifiers":[
            {"$InvisibleModifier":"","resourceType":"InvisibleModifier","resourceVersion":"2.0",},
          ],"name":"position","resourceType":"GMRealTrack","resourceVersion":"2.0","trackColour":4282936306,"tracks":[],"traits":0,},
        {"$GMRealTrack":"","%Name":"rotation","builtinName":8,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":true,"keyframes":{"$KeyframeStore<RealKeyframe>":"","Keyframes":[
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.0,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"3df506aa-6547-4d27-bf8e-5ac3b80fccd4","IsCreationKey":true,"Key":30.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
            ],"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"2.0",},"modifiers":[
            {"$InvisibleModifier":"","resourceType":"InvisibleModifier","resourceVersion":"2.0",},
          ],"name":"rotation","resourceType":"GMRealTrack","resourceVersion":"2.0","trackColour":4282936306,"tracks":[],"traits":0,},
        {"$GMRealTrack":"","%Name":"scale","builtinName":15,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"$KeyframeStore<RealKeyframe>":"","Keyframes":[
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.67902946,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                  "1":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.6220348,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"5e56d2b1-8b28-4495-82bb-13e936e48085","IsCreationKey":false,"Key":30.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":4.61153,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                  "1":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.6170348,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"41f7838d-af10-4817-bbd3-b9fcd1a240e1","IsCreationKey":false,"Key":32.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.79201484,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                  "1":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.5270348,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"3bb73112-27ec-4dd3-8fb1-d3837cdb1dd0","IsCreationKey":false,"Key":43.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.61652946,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                  "1":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.5595348,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"8220575f-ede1-4299-8e3a-4511d16375df","IsCreationKey":false,"Key":53.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
            ],"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"2.0",},"modifiers":[
            {"$InvisibleModifier":"","resourceType":"InvisibleModifier","resourceVersion":"2.0",},
          ],"name":"scale","resourceType":"GMRealTrack","resourceVersion":"2.0","trackColour":4282936306,"tracks":[],"traits":0,},
      ],"traits":0,},
    {"$GMGraphicTrack":"","%Name":"spr_guardian_attack","builtinName":0,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"$KeyframeStore<AssetSpriteKeyframe>":"","Keyframes":[
          {"$Keyframe<AssetSpriteKeyframe>":"","Channels":{
              "0":{"$AssetSpriteKeyframe":"","Id":{"name":"spr_guardian_attack","path":"sprites/spr_guardian_attack/spr_guardian_attack.yy",},"resourceType":"AssetSpriteKeyframe","resourceVersion":"2.0",},
            },"Disabled":false,"id":"2fc98ec5-5928-4734-9ce8-e0ea33f84930","IsCreationKey":false,"Key":0.0,"Length":10.0,"resourceType":"Keyframe<AssetSpriteKeyframe>","resourceVersion":"2.0","Stretch":false,},
          {"$Keyframe<AssetSpriteKeyframe>":"","Channels":{
              "0":{"$AssetSpriteKeyframe":"","Id":{"name":"spr_guardian_attack","path":"sprites/spr_guardian_attack/spr_guardian_attack.yy",},"resourceType":"AssetSpriteKeyframe","resourceVersion":"2.0",},
            },"Disabled":false,"id":"149f06a7-255c-4e7c-af07-fccc3770c0e7","IsCreationKey":false,"Key":10.0,"Length":62.0,"resourceType":"Keyframe<AssetSpriteKeyframe>","resourceVersion":"2.0","Stretch":false,},
        ],"resourceType":"KeyframeStore<AssetSpriteKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"spr_guardian_attack","resourceType":"GMGraphicTrack","resourceVersion":"2.0","trackColour":4294068430,"tracks":[
        {"$GMRealTrack":"","%Name":"origin","builtinName":16,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":true,"keyframes":{"$KeyframeStore<RealKeyframe>":"","Keyframes":[
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.0,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                  "1":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.0,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"0fffb70a-b95a-4de5-bc4c-bf309b17c29e","IsCreationKey":true,"Key":0.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
            ],"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"origin","resourceType":"GMRealTrack","resourceVersion":"2.0","trackColour":4294068430,"tracks":[],"traits":0,},
        {"$GMRealTrack":"","%Name":"position","builtinName":14,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"$KeyframeStore<RealKeyframe>":"","Keyframes":[
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.0,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                  "1":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.0,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"e75210e8-a909-47dc-90fa-e94a55c64aaf","IsCreationKey":false,"Key":0.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
            ],"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"position","resourceType":"GMRealTrack","resourceVersion":"2.0","trackColour":4294068430,"tracks":[],"traits":0,},
        {"$GMRealTrack":"","%Name":"rotation","builtinName":8,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":true,"keyframes":{"$KeyframeStore<RealKeyframe>":"","Keyframes":[
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":0.0,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"2cdb429e-4f89-45e1-a3e4-d8cbcbc4ba35","IsCreationKey":true,"Key":0.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
            ],"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"rotation","resourceType":"GMRealTrack","resourceVersion":"2.0","trackColour":4294068430,"tracks":[],"traits":0,},
        {"$GMRealTrack":"","%Name":"scale","builtinName":15,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":true,"keyframes":{"$KeyframeStore<RealKeyframe>":"","Keyframes":[
              {"$Keyframe<RealKeyframe>":"","Channels":{
                  "0":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":1.0,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                  "1":{"$RealKeyframe":"","AnimCurveId":null,"EmbeddedAnimCurve":null,"RealValue":1.0,"resourceType":"RealKeyframe","resourceVersion":"2.0",},
                },"Disabled":false,"id":"e7699f3d-95aa-4b45-ba0e-0f12fa036d33","IsCreationKey":true,"Key":0.0,"Length":1.0,"resourceType":"Keyframe<RealKeyframe>","resourceVersion":"2.0","Stretch":false,},
            ],"resourceType":"KeyframeStore<RealKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"scale","resourceType":"GMRealTrack","resourceVersion":"2.0","trackColour":4294068430,"tracks":[],"traits":0,},
      ],"traits":0,},
  ],
  "visibleRange":null,
  "volume":1.0,
  "xorigin":0,
  "yorigin":0,
}