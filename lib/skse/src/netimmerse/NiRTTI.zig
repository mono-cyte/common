const std = @import("std");
const relocation = @import("../relocation.zig");
//
/// 继承树
///
/// BSFaceGenMorphData
///     BSFaceGenMorphDataHead
///     BSFaceGenMorphDataHair
///
/// BSTempEffect
///     BSTempEffectDebris
///     BSTempEffectGeometryDecal
///     BSTempEffectParticle
///     BSTempEffectSimpleDecal
///     BSTempEffectSPG
///     ReferenceEffect
///         ModelReferenceEffect
///         ShaderReferenceEffect
///         SummonPlacementEffect
///
/// NiObject
///     NiObjectNET
///         NiAVObject
///             NiNode
///                 BGSDecalNode
///                 BSFaceGenNiNode
///                 NiSwitchNode
///                 BSFlattenedBoneTree
///                 NiBillboardNode
///                 NiBSPNode
///                 BSTempNodeManager
///                 BSTempNode
///                 BSPortalSharedNode
///                 BSParticleSystemManager
///                 BSSceneGraph
///                     SceneGraph
///                 BSMasterParticleSystem
///                 BSNiNode
///                     BSValueNode
///                     BSRangeNode
///                         BSBlastNode
///                         BSDebrisNode
///                         BSDamageStage
///                     BSMultiBoundNode
///                     BSOrderedNode
///                 BSFadeNode
///                 BSLeafAnimNode
///                 BSTreeNode
///                 ShadowSceneNode
///                 BSClearZNode
///             NiLight
///                 NiPointLight
///                     NiSpotLight
///                 NiDirectionalLight
///                 NiAmbientLight
///             NiCamera
///                 BSCubeMapCamera
///             BSGeometry
///                 BSTriShape
///                     BSDynamicTriShape
///                     BSSubIndexTriShape
///                         BSSubIndexLandTriShape
///                     BSInstanceTriShape
///                         BSMultiStreamInstanceTriShape
///                     BSMultiIndexTriShape
///                         BSLODMultiIndexTriShape
///                     BSMeshLODTriShape
///                 NiParticles
///                     NiParticleMeshes
///                     NiParticleSystem
///                         NiMeshParticleSystem
///                         BSStripParticleSystem
///                 BSLines
///                     BSDynamicLines
///             NiGeometry
///                 NiTriBasedGeom
///                     NiTriShape
///                         BSLODTriShape
///                         BSSegmentedTriShape
///                     NiTriStrips
///         NiProperty
///             NiAlphaProperty
///             NiShadeProperty
///                 BSShaderProperty
///                     BSLightingShaderProperty
///                     BSGrassShaderProperty
///                     BSEffectShaderProperty
///                     BSWaterShaderProperty
///                     BSBloodSplatterShaderProperty
///                     BSParticleShaderProperty
///                     BSSkyShaderProperty
///                     BSDistantTreeShaderProperty
///             NiFogProperty
///                 BSFogProperty
///         NiSequenceStreamHelper
///     BSDismemberSkinInstance
///     NiTimeController
///         REFRSyncController
///         BSDoorHavokController
///         BSPlayerDistanceCheckController
///         BSSimpleScaleController
///         NiControllerManager
///         NiInterpController
///             NiMultiTargetTransformController
///             BSMultiTargetTreadTransfController
///             NiSingleInterpController
///                 NiTransformController
///                 NiExtraDataController
///                     NiFloatExtraDataController
///                     NiColorExtraDataController
///                     NiFloatsExtraDataController
///                     NiFloatsExtraDataPoint3Controller
///                 NiPoint3InterpController
///                     NiLightColorController
///                     BSLightingShaderPropertyColorController
///                     BSEffectShaderPropertyColorController
///                 NiFloatInterpController
///                     NiLightDimmerController
///                     BSFrustumFOVController
///                     BSLightingShaderPropertyFloatController
///                     BSLightingShaderPropertyUShortController
///                     BSEffectShaderPropertyFloatController
///                     BSNiAlphaPropertyTestRefController
///                 NiBoolInterpController
///                     NiVisController
///                 NiPSysModifierCtlr
///                     NiPSysEmitterCtlr
///                         BSPSysMultiTargetEmitterCtlr
///                     NiPSysModifierFloatCtlr
///                         NiPSysAirFieldAirFrictionCtlr
///                         NiPSysAirFieldInheritVelocityCtlr
///                         NiPSysAirFieldSpreadCtlr
///                         NiPSysEmitterDeclinationCtlr
///                         NiPSysEmitterDeclinationVarCtlr
///                         NiPSysEmitterInitialRadiusCtlr
///                         NiPSysEmitterLifeSpanCtlr
///                         NiPSysEmitterPlanarAngleCtlr
///                         NiPSysEmitterPlanarAngleVarCtlr
///                         NiPSysEmitterSpeedCtlr
///                         NiPSysFieldAttenuationCtlr
///                         NiPSysFieldMagnitudeCtlr
///                         NiPSysFieldMaxDistanceCtlr
///                         NiPSysGravityStrengthCtlr
///                         NiPSysInitialRotAngleCtlr
///                         NiPSysInitialRotAngleVarCtlr
///                         NiPSysInitialRotSpeedCtlr
///                         NiPSysInitialRotSpeedVarCtlr
///                     NiPSysModifierBoolCtlr
///                         NiPSysModifierActiveCtlr
///             BSProceduralLightningController
///         NiKeyframeManager
///         NiLookAtController
///         NiPathController
///         NiFloatController
///             NiRollController
///         NiPSysUpdateCtlr
///         NiPSysResetOnLoopCtlr
///         NiBSBoneLODController
///         BSLagBoneController
///         bhkBlendController
///     NiExtraData
///         BSSplatterExtraData
///         BGSAddonNodeSoundHandleExtra
///         BSFaceGenAnimationData
///         BSFaceGenModelExtraData
///         BSFaceGenBaseMorphExtraData
///         NiStringsExtraData
///         NiStringExtraData
///         NiVertWeightsExtraData
///         NiBinaryExtraData
///         NiBooleanExtraData
///             BSDistantObjectLargeRefExtraData
///         NiColorExtraData
///         NiFloatExtraData
///         NiFloatsExtraData
///         NiIntegerExtraData
///             BSXFlags
///             BSDecalPlacementVectorExtraData
///         NiIntegersExtraData
///             BSWArray
///         NiSwitchStringExtraData
///         NiVectorExtraData
///         NiTextKeyExtraData
///         PArrayPoint
///         BSBodyMorphOffsetsExtraData
///         BSBehaviorGraphExtraData
///         BSFurnitureMarkerNode
///         BSBound
///         BSBoneMap
///         BSAnimInteractionMarker
///         BSInvMarker
///         BSBoneLODExtraData
///         BSNonUniformScaleExtraData
///         bhkRagdollTemplate
///         bhkExtraData
///         DebugTextExtraData
///     NiGeometryData
///         NiTriBasedGeomData
///             NiTriShapeData
///             NiTriStripsData
///     NiTexture
///         NiSourceTexture
///     NiSkinPartition
///     NiSkinInstance
///     NiAVObjectPalette
///         NiDefaultAVObjectPalette
///     NiSkinData
///     NiParticlesData
///         NiParticleMeshesData
///         NiPSysData
///             NiMeshPSysData
///             BSStripPSysData
///     NiAdditionalGeometryData
///     NiAccumulator
///         NiBackToFrontAccumulator
///             NiAlphaAccumulator
///                 BSShaderAccumulator
///     NiControllerSequence
///         BSAnimGroupSequence
///     NiFloatData
///     NiColorData
///     NiInterpolator
///         NiBlendInterpolator
///             NiBlendTransformInterpolator
///             NiBlendFloatInterpolator
///             NiBlendAccumTransformInterpolator
///             BSBlendTreadTransfInterpolator
///             NiBlendBoolInterpolator
///             NiBlendColorInterpolator
///             NiBlendPoint3Interpolator
///             NiBlendQuaternionInterpolator
///         NiKeyBasedInterpolator
///             NiFloatInterpolator
///             NiColorInterpolator
///             NiTransformInterpolator
///                 BSRotAccumTransfInterpolator
///             NiPathInterpolator
///             NiBoolInterpolator
///                 NiBoolTimelineInterpolator
///             NiPoint3Interpolator
///             NiQuaternionInterpolator
///             BSTreadTransfInterpolator
///         NiLookAtInterpolator
///         NiBSplineInterpolator
///             NiBSplineColorInterpolator
///                 NiBSplineCompColorInterpolator
///             NiBSplineFloatInterpolator
///                 NiBSplineCompFloatInterpolator
///             NiBSplinePoint3Interpolator
///                 NiBSplineCompPoint3Interpolator
///             NiBSplineTransformInterpolator
///                 NiBSplineCompTransformInterpolator
///     NiTransformData
///     NiPosData
///     NiBoolData
///     NiBSplineBasisData
///     NiBSplineData
///     NiMorphData
///     NiRotData
///     NiSequence
///     NiStringPalette
///     NiUVData
///     BSAnimNote
///         BSGrabIKNote
///         BSLookIKNote
///     BSAnimNotes
///     NiPSysModifier
///         NiPSysGravityModifier
///         NiPSysEmitter
///             NiPSysMeshEmitter
///             NiPSysVolumeEmitter
///                 NiPSysCylinderEmitter
///                 NiPSysBoxEmitter
///                 NiPSysSphereEmitter
///                 BSPSysArrayEmitter
///         NiPSysMeshUpdateModifier
///             BSPSysHavokUpdateModifier
///         NiPSysAgeDeathModifier
///         NiPSysBombModifier
///         NiPSysBoundUpdateModifier
///         NiPSysColliderManager
///         NiPSysColorModifier
///         NiPSysDragModifier
///         NiPSysGrowFadeModifier
///         NiPSysPositionModifier
///         NiPSysRotationModifier
///         NiPSysSpawnModifier
///         BSPSysRecycleBoundModifier
///         BSPSysInheritVelocityModifier
///         NiPSysFieldModifier
///             NiPSysAirFieldModifier
///             NiPSysDragFieldModifier
///             NiPSysGravityFieldModifier
///             NiPSysRadialFieldModifier
///             NiPSysTurbulenceFieldModifier
///             NiPSysVortexFieldModifier
///         BSWindModifier
///         BSParentVelocityModifier
///         BSPSysStripUpdateModifier
///         BSPSysSubTexModifier
///         BSPSysScaleModifier
///         BSPSysSimpleColorModifier
///         BSPSysLODModifier
///     NiPSysEmitterCtlrData
///     NiPSysCollider
///         NiPSysPlanarCollider
///         NiPSysSphericalCollider
///     BSMultiBound
///     BSMultiBoundRoom
///     BSOcclusionShape
///     BSMultiBoundShape
///         BSMultiBoundAABB
///             BSMultiBoundOBB
///         BSMultiBoundSphere
///         BSMultiBoundCapsule
///     BSOcclusionBox
///     BSOcclusionPlane
///         BSPortal
///     BSReference
///     BSNodeReferences
///     bhkRefObject
///         bhkWorld
///             bhkWorldM
///         bhkSerializable
///             bhkWorldObject
///                 bhkEntity
///                     bhkRigidBody
///                         bhkRigidBodyT
///                 bhkPhantom
///                     bhkAabbPhantom
///                         bhkAutoWater
///                         bhkAvoidBox
///                     bhkShapePhantom
///                         bhkSimpleShapePhantom
///                             bhkCollisionBox
///                         bhkCachingShapePhantom
///             bhkShape
///                 bhkSphereRepShape
///                     bhkConvexShape
///                         bhkCapsuleShape
///                         bhkBoxShape
///                         bhkSphereShape
///                         bhkConvexSweepShape
///                         bhkConvexTransformShape
///                         bhkConvexTranslateShape
///                         bhkConvexVerticesShape
///                             bhkCharControllerShape
///                         bhkCylinderShape
///                         bhkTriangleShape
///                     bhkMultiSphereShape
///                 bhkBvTreeShape
///                     bhkTriSampledHeightFieldBvTreeShape
///                     bhkMoppBvTreeShape
///                 bhkTransformShape
///                 bhkShapeCollection
///                     bhkNiTriStripsShape
///                     bhkPackedNiTriStripsShape
///                     bhkCompressedMeshShape
///                     bhkListShape
///                 bhkHeightFieldShape
///                     bhkPlaneShape
///             bhkConstraint
///                 bhkLimitedHingeConstraint
///                 bhkMalleableConstraint
///                 bhkPrismaticConstraint
///                 bhkHingeConstraint
///                 bhkBallAndSocketConstraint
///                 bhkBallSocketConstraintChain
///                 bhkGroupConstraint
///                 bhkHingeLimitsConstraint
///                 bhkRagdollConstraint
///                 bhkRagdollLimitsConstraint
///                 bhkStiffSpringConstraint
///                 bhkWheelConstraint
///                 bhkBreakableConstraint
///                 bhkGenericConstraint
///                     bhkFixedConstraint
///                 bhkConstraintChain
///                 bhkPointToPathConstraint
///             bhkAction
///                 bhkUnaryAction
///                     bhkTiltPreventAction
///                     bhkWheelAction
///                     bhkMouseSpringAction
///                     bhkLiquidAction
///                     bhkMotorAction
///                     bhkOrientHingedBodyAction
///                 bhkBinaryAction
///                     bhkAngularDashpotAction
///                     bhkDashpotAction
///                     bhkSpringAction
///             bhkCharacterProxy
///             bhkCharacterRigidBody
///     hkPackedNiTriStripsData
///     bhkRagdollTemplateData
///     bhkCompressedMeshShapeData
///     bhkPoseArray
///     BSTextureSet
///         BSShaderTextureSet
///     NiCollisionObject
///         NiCollisionData
///         bhkNiCollisionObject
///             bhkCollisionObject
///                 bhkCartTether
///                 bhkBlendCollisionObject
///                     bhkAttachmentCollisionObject
///                     WeaponObject
///             bhkPCollisionObject
///                 bhkSPCollisionObject
///
/// NiCullingProcess
///     BSCullingProcess
///         BSGeometryListCullingProcess
///         BSParabolicCullingProcess
///     BSFadeNodeCuller
///
/// bhkPositionConstraintMotor
///
/// bhkVelocityConstraintMotor
///
/// bhkSpringDamperConstraintMotor
//

// NiObject 前向声明(稍后在其它文件中定义)
pub const NiObject = @import("NiObject.zig").NiObject;

/// 08
/// NiRTTI - 运行时类型信息
pub const NiRTTI = extern struct {
    name: [*:0]const u8, // 00 - 类型名称
    parent: ?*const NiRTTI, // 08 - 父类型 RTTI 指针
};

/// 类型转换函数
pub fn DoNiRTTICast(src: ?*NiObject, typeInfo: *const NiRTTI) ?*NiObject {
    const typeAddr = @intFromPtr(typeInfo) + relocation.RelocationManager.s_baseAddr;
    if (src) |s| {
        const iter: ?*const NiRTTI = s.vtable.GetRTTI(s); // 注意后续修改
        while (iter) |i| : (i = i.parent) {
            if (i == @as(*NiRTTI, @ptrFromInt(typeAddr))) {
                return s;
            }
        }
    } else {
        return null;
    }
}

/// 类型检查函数
pub fn IsType(rtti: ?*NiRTTI, typeInfo: *const NiRTTI) bool {
    const typeAddr = @intFromPtr(typeInfo) + relocation.RelocationManager.s_baseAddr;
    if (rtti) |r| {
        return @intFromPtr(r) == typeAddr;
    } else {
        return false;
    }
}

var NiRTTI_BGSDecalNode: *const NiRTTI = @ptrFromInt(0x020FC190);
var NiRTTI_BSAnimGroupSequence: *const NiRTTI = @ptrFromInt(0x020FC2F0);
var NiRTTI_BSSplatterExtraData: *const NiRTTI = @ptrFromInt(0x030FD340);
var NiRTTI_BGSAddonNodeSoundHandleExtra: *const NiRTTI = @ptrFromInt(0x030FD7A8);
var NiRTTI_REFRSyncController: *const NiRTTI = @ptrFromInt(0x031377B0);
var NiRTTI_bhkCartTether: *const NiRTTI = @ptrFromInt(0x03138E18);
var NiRTTI_bhkTiltPreventAction: *const NiRTTI = @ptrFromInt(0x03138E28);
var NiRTTI_bhkWheelAction: *const NiRTTI = @ptrFromInt(0x03138E38);
var NiRTTI_BSFaceGenAnimationData: *const NiRTTI = @ptrFromInt(0x03139478);
var NiRTTI_BSFaceGenModelExtraData: *const NiRTTI = @ptrFromInt(0x0313F9A0);
var NiRTTI_BSFaceGenBaseMorphExtraData: *const NiRTTI = @ptrFromInt(0x0313F9C8);
var NiRTTI_BSFaceGenMorphData: *const NiRTTI = @ptrFromInt(0x0313F9D8);
var NiRTTI_BSFaceGenMorphDataHead: *const NiRTTI = @ptrFromInt(0x0313F9E8);
var NiRTTI_BSFaceGenMorphDataHair: *const NiRTTI = @ptrFromInt(0x0313F9F8);
var NiRTTI_BSFaceGenNiNode: *const NiRTTI = @ptrFromInt(0x0313FA38);
var NiRTTI_BSTempEffect: *const NiRTTI = @ptrFromInt(0x03144E08);
var NiRTTI_BSTempEffectDebris: *const NiRTTI = @ptrFromInt(0x03144E88);
var NiRTTI_BSTempEffectGeometryDecal: *const NiRTTI = @ptrFromInt(0x03144EA8);
var NiRTTI_BSTempEffectParticle: *const NiRTTI = @ptrFromInt(0x03144F58);
var NiRTTI_BSTempEffectSimpleDecal: *const NiRTTI = @ptrFromInt(0x03144F80);
var NiRTTI_BSTempEffectSPG: *const NiRTTI = @ptrFromInt(0x03144F98);
var NiRTTI_bhkAutoWater: *const NiRTTI = @ptrFromInt(0x0315C380);
var NiRTTI_ModelReferenceEffect: *const NiRTTI = @ptrFromInt(0x03169C58);
var NiRTTI_ReferenceEffect: *const NiRTTI = @ptrFromInt(0x03169C90);
var NiRTTI_ShaderReferenceEffect: *const NiRTTI = @ptrFromInt(0x03169CC0);
var NiRTTI_SummonPlacementEffect: *const NiRTTI = @ptrFromInt(0x03169CF0);
var NiRTTI_SceneGraph: *const NiRTTI = @ptrFromInt(0x03199378);
var NiRTTI_BSDoorHavokController: *const NiRTTI = @ptrFromInt(0x0319B098);
var NiRTTI_BSPlayerDistanceCheckController: *const NiRTTI = @ptrFromInt(0x0319B0A8);
var NiRTTI_BSSimpleScaleController: *const NiRTTI = @ptrFromInt(0x0319B0B8);
var NiRTTI_NiObject: *const NiRTTI = @ptrFromInt(0x03272CB0);
var NiRTTI_NiAVObject: *const NiRTTI = @ptrFromInt(0x03272CE8);
var NiRTTI_NiNode: *const NiRTTI = @ptrFromInt(0x03272D08);
var NiRTTI_NiObjectNET: *const NiRTTI = @ptrFromInt(0x03272E88);
var NiRTTI_NiLight: *const NiRTTI = @ptrFromInt(0x03272EE0);
var NiRTTI_NiSwitchNode: *const NiRTTI = @ptrFromInt(0x03272EF0);
var NiRTTI_NiStringsExtraData: *const NiRTTI = @ptrFromInt(0x03272F00);
var NiRTTI_NiCamera: *const NiRTTI = @ptrFromInt(0x03272F10);
var NiRTTI_BSTriShape: *const NiRTTI = @ptrFromInt(0x03272F28);
var NiRTTI_NiProperty: *const NiRTTI = @ptrFromInt(0x03272F38);
var NiRTTI_NiAlphaProperty: *const NiRTTI = @ptrFromInt(0x03272F50);
var NiRTTI_NiSourceTexture: *const NiRTTI = @ptrFromInt(0x03273F88);
var NiRTTI_BSFlattenedBoneTree: *const NiRTTI = @ptrFromInt(0x03273F98);
var NiRTTI_BSDismemberSkinInstance: *const NiRTTI = @ptrFromInt(0x03273FE0);
var NiRTTI_NiStringExtraData: *const NiRTTI = @ptrFromInt(0x03273FF0);
var NiRTTI_NiTimeController: *const NiRTTI = @ptrFromInt(0x03274000);
var NiRTTI_NiExtraData: *const NiRTTI = @ptrFromInt(0x03274020);
var NiRTTI_NiGeometryData: *const NiRTTI = @ptrFromInt(0x03274030);
var NiRTTI_BSGeometry: *const NiRTTI = @ptrFromInt(0x03274048);
var NiRTTI_BSDynamicTriShape: *const NiRTTI = @ptrFromInt(0x03274060);
var NiRTTI_NiPointLight: *const NiRTTI = @ptrFromInt(0x03274070);
var NiRTTI_NiDefaultAVObjectPalette: *const NiRTTI = @ptrFromInt(0x03274080);
var NiRTTI_NiBillboardNode: *const NiRTTI = @ptrFromInt(0x032740A8);
var NiRTTI_NiDirectionalLight: *const NiRTTI = @ptrFromInt(0x032740B8);
var NiRTTI_NiCullingProcess: *const NiRTTI = @ptrFromInt(0x032740C8);
var NiRTTI_NiParticles: *const NiRTTI = @ptrFromInt(0x032740E0);
var NiRTTI_NiTexture: *const NiRTTI = @ptrFromInt(0x03274120);
var NiRTTI_NiSkinPartition: *const NiRTTI = @ptrFromInt(0x03274230);
var NiRTTI_NiVertWeightsExtraData: *const NiRTTI = @ptrFromInt(0x03274240);
var NiRTTI_NiSkinInstance: *const NiRTTI = @ptrFromInt(0x03274250);
var NiRTTI_NiAVObjectPalette: *const NiRTTI = @ptrFromInt(0x03274260);
var NiRTTI_NiGeometry: *const NiRTTI = @ptrFromInt(0x03274270);
var NiRTTI_NiSkinData: *const NiRTTI = @ptrFromInt(0x032742A0);
var NiRTTI_NiShadeProperty: *const NiRTTI = @ptrFromInt(0x032742B0);
var NiRTTI_NiAlphaAccumulator: *const NiRTTI = @ptrFromInt(0x032742C8);
var NiRTTI_NiAmbientLight: *const NiRTTI = @ptrFromInt(0x032742D8);
var NiRTTI_NiBooleanExtraData: *const NiRTTI = @ptrFromInt(0x032742F8);
var NiRTTI_NiBSPNode: *const NiRTTI = @ptrFromInt(0x03274308);
var NiRTTI_NiColorExtraData: *const NiRTTI = @ptrFromInt(0x03274318);
var NiRTTI_NiFloatExtraData: *const NiRTTI = @ptrFromInt(0x03274328);
var NiRTTI_NiFloatsExtraData: *const NiRTTI = @ptrFromInt(0x03274338);
var NiRTTI_NiFogProperty: *const NiRTTI = @ptrFromInt(0x03274348);
var NiRTTI_NiIntegerExtraData: *const NiRTTI = @ptrFromInt(0x03274360);
var NiRTTI_NiIntegersExtraData: *const NiRTTI = @ptrFromInt(0x03274370);
var NiRTTI_NiParticlesData: *const NiRTTI = @ptrFromInt(0x032743B8);
var NiRTTI_NiParticleMeshesData: *const NiRTTI = @ptrFromInt(0x032743C8);
var NiRTTI_NiParticleMeshes: *const NiRTTI = @ptrFromInt(0x032743D8);
var NiRTTI_NiSpotLight: *const NiRTTI = @ptrFromInt(0x032743E8);
var NiRTTI_NiSwitchStringExtraData: *const NiRTTI = @ptrFromInt(0x032743F8);
var NiRTTI_NiTriShapeData: *const NiRTTI = @ptrFromInt(0x03274408);
var NiRTTI_NiTriShape: *const NiRTTI = @ptrFromInt(0x03274418);
var NiRTTI_NiTriStripsData: *const NiRTTI = @ptrFromInt(0x03274428);
var NiRTTI_NiTriStrips: *const NiRTTI = @ptrFromInt(0x03274438);
var NiRTTI_NiVectorExtraData: *const NiRTTI = @ptrFromInt(0x03274448);
var NiRTTI_BSLODTriShape: *const NiRTTI = @ptrFromInt(0x03274470);
var NiRTTI_NiAdditionalGeometryData: *const NiRTTI = @ptrFromInt(0x03274480);
var NiRTTI_BSSegmentedTriShape: *const NiRTTI = @ptrFromInt(0x03274498);
var NiRTTI_NiBackToFrontAccumulator: *const NiRTTI = @ptrFromInt(0x032744D0);
var NiRTTI_NiAccumulator: *const NiRTTI = @ptrFromInt(0x032744E0);
var NiRTTI_NiTriBasedGeomData: *const NiRTTI = @ptrFromInt(0x032744F0);
var NiRTTI_NiTriBasedGeom: *const NiRTTI = @ptrFromInt(0x03274500);
var NiRTTI_NiCollisionData: *const NiRTTI = @ptrFromInt(0x03274540);
var NiRTTI_NiControllerManager: *const NiRTTI = @ptrFromInt(0x032745D8);
var NiRTTI_NiControllerSequence: *const NiRTTI = @ptrFromInt(0x032745F8);
var NiRTTI_NiBlendInterpolator: *const NiRTTI = @ptrFromInt(0x03274628);
var NiRTTI_NiMultiTargetTransformController: *const NiRTTI = @ptrFromInt(0x03274638);
var NiRTTI_BSMultiTargetTreadTransfController: *const NiRTTI = @ptrFromInt(0x03274648);
var NiRTTI_NiInterpController: *const NiRTTI = @ptrFromInt(0x03274658);
var NiRTTI_NiFloatData: *const NiRTTI = @ptrFromInt(0x03275428);
var NiRTTI_NiFloatInterpolator: *const NiRTTI = @ptrFromInt(0x03275438);
var NiRTTI_NiColorData: *const NiRTTI = @ptrFromInt(0x03275448);
var NiRTTI_NiColorInterpolator: *const NiRTTI = @ptrFromInt(0x03275458);
var NiRTTI_NiSingleInterpController: *const NiRTTI = @ptrFromInt(0x03275468);
var NiRTTI_NiTransformInterpolator: *const NiRTTI = @ptrFromInt(0x03275478);
var NiRTTI_NiPathInterpolator: *const NiRTTI = @ptrFromInt(0x03275488);
var NiRTTI_NiBlendTransformInterpolator: *const NiRTTI = @ptrFromInt(0x032754A8);
var NiRTTI_NiBlendFloatInterpolator: *const NiRTTI = @ptrFromInt(0x032754B8);
var NiRTTI_NiFloatExtraDataController: *const NiRTTI = @ptrFromInt(0x032754C8);
var NiRTTI_NiTransformController: *const NiRTTI = @ptrFromInt(0x032754D8);
var NiRTTI_NiBlendAccumTransformInterpolator: *const NiRTTI = @ptrFromInt(0x032754E8);
var NiRTTI_NiInterpolator: *const NiRTTI = @ptrFromInt(0x03275500);
var NiRTTI_BSBlendTreadTransfInterpolator: *const NiRTTI = @ptrFromInt(0x03275520);
var NiRTTI_NiKeyBasedInterpolator: *const NiRTTI = @ptrFromInt(0x03275538);
var NiRTTI_NiTransformData: *const NiRTTI = @ptrFromInt(0x032755B8);
var NiRTTI_NiPosData: *const NiRTTI = @ptrFromInt(0x032755C8);
var NiRTTI_NiBlendBoolInterpolator: *const NiRTTI = @ptrFromInt(0x032755D8);
var NiRTTI_NiBlendColorInterpolator: *const NiRTTI = @ptrFromInt(0x032755E8);
var NiRTTI_NiBlendPoint3Interpolator: *const NiRTTI = @ptrFromInt(0x032755F8);
var NiRTTI_NiBlendQuaternionInterpolator: *const NiRTTI = @ptrFromInt(0x03275608);
var NiRTTI_NiBoolData: *const NiRTTI = @ptrFromInt(0x03275618);
var NiRTTI_NiBoolInterpolator: *const NiRTTI = @ptrFromInt(0x03275628);
var NiRTTI_NiBoolTimelineInterpolator: *const NiRTTI = @ptrFromInt(0x03275638);
var NiRTTI_NiBSplineBasisData: *const NiRTTI = @ptrFromInt(0x03275648);
var NiRTTI_NiBSplineData: *const NiRTTI = @ptrFromInt(0x03275658);
var NiRTTI_NiBSplineColorInterpolator: *const NiRTTI = @ptrFromInt(0x03275668);
var NiRTTI_NiBSplineCompColorInterpolator: *const NiRTTI = @ptrFromInt(0x03275678);
var NiRTTI_NiBSplineCompFloatInterpolator: *const NiRTTI = @ptrFromInt(0x03275688);
var NiRTTI_NiBSplineCompPoint3Interpolator: *const NiRTTI = @ptrFromInt(0x03275698);
var NiRTTI_NiBSplineCompTransformInterpolator: *const NiRTTI = @ptrFromInt(0x032756A8);
var NiRTTI_NiBSplineFloatInterpolator: *const NiRTTI = @ptrFromInt(0x032756B8);
var NiRTTI_NiBSplinePoint3Interpolator: *const NiRTTI = @ptrFromInt(0x032756C8);
var NiRTTI_NiBSplineTransformInterpolator: *const NiRTTI = @ptrFromInt(0x032756D8);
var NiRTTI_NiColorExtraDataController: *const NiRTTI = @ptrFromInt(0x032756E8);
var NiRTTI_NiFloatsExtraDataController: *const NiRTTI = @ptrFromInt(0x032756F8);
var NiRTTI_NiFloatsExtraDataPoint3Controller: *const NiRTTI = @ptrFromInt(0x03275708);
var NiRTTI_NiKeyframeManager: *const NiRTTI = @ptrFromInt(0x03275720);
var NiRTTI_NiLightColorController: *const NiRTTI = @ptrFromInt(0x03275730);
var NiRTTI_NiLightDimmerController: *const NiRTTI = @ptrFromInt(0x03275740);
var NiRTTI_NiLookAtController: *const NiRTTI = @ptrFromInt(0x03275750);
var NiRTTI_NiLookAtInterpolator: *const NiRTTI = @ptrFromInt(0x03275760);
var NiRTTI_NiMorphData: *const NiRTTI = @ptrFromInt(0x03275770);
var NiRTTI_NiPathController: *const NiRTTI = @ptrFromInt(0x03275780);
var NiRTTI_NiPoint3Interpolator: *const NiRTTI = @ptrFromInt(0x03275790);
var NiRTTI_NiQuaternionInterpolator: *const NiRTTI = @ptrFromInt(0x032757A0);
var NiRTTI_NiRollController: *const NiRTTI = @ptrFromInt(0x032757B0);
var NiRTTI_NiRotData: *const NiRTTI = @ptrFromInt(0x032757C0);
var NiRTTI_NiSequence: *const NiRTTI = @ptrFromInt(0x032757D0);
var NiRTTI_NiSequenceStreamHelper: *const NiRTTI = @ptrFromInt(0x032757F0);
var NiRTTI_NiStringPalette: *const NiRTTI = @ptrFromInt(0x03275800);
var NiRTTI_NiTextKeyExtraData: *const NiRTTI = @ptrFromInt(0x03275810);
var NiRTTI_NiUVData: *const NiRTTI = @ptrFromInt(0x03275820);
var NiRTTI_NiVisController: *const NiRTTI = @ptrFromInt(0x03275830);
var NiRTTI_BSAnimNote: *const NiRTTI = @ptrFromInt(0x03275840);
var NiRTTI_BSAnimNotes: *const NiRTTI = @ptrFromInt(0x03275850);
var NiRTTI_BSGrabIKNote: *const NiRTTI = @ptrFromInt(0x03275860);
var NiRTTI_BSLookIKNote: *const NiRTTI = @ptrFromInt(0x03275870);
var NiRTTI_BSRotAccumTransfInterpolator: *const NiRTTI = @ptrFromInt(0x03275880);
var NiRTTI_BSTreadTransfInterpolator: *const NiRTTI = @ptrFromInt(0x03275890);
var NiRTTI_BSFrustumFOVController: *const NiRTTI = @ptrFromInt(0x032758A0);
var NiRTTI_NiExtraDataController: *const NiRTTI = @ptrFromInt(0x03275938);
var NiRTTI_NiBSplineInterpolator: *const NiRTTI = @ptrFromInt(0x03275948);
var NiRTTI_NiPoint3InterpController: *const NiRTTI = @ptrFromInt(0x03275958);
var NiRTTI_NiFloatInterpController: *const NiRTTI = @ptrFromInt(0x03275968);
var NiRTTI_NiFloatController: *const NiRTTI = @ptrFromInt(0x03275978);
var NiRTTI_NiBoolInterpController: *const NiRTTI = @ptrFromInt(0x03275988);
var NiRTTI_NiParticleSystem: *const NiRTTI = @ptrFromInt(0x032759A0);
var NiRTTI_NiPSysEmitterCtlr: *const NiRTTI = @ptrFromInt(0x032759B0);
var NiRTTI_NiPSysGravityModifier: *const NiRTTI = @ptrFromInt(0x032759C0);
var NiRTTI_BSPSysHavokUpdateModifier: *const NiRTTI = @ptrFromInt(0x032759D0);
var NiRTTI_NiMeshParticleSystem: *const NiRTTI = @ptrFromInt(0x032759E8);
var NiRTTI_NiPSysCylinderEmitter: *const NiRTTI = @ptrFromInt(0x03275A00);
var NiRTTI_BSStripParticleSystem: *const NiRTTI = @ptrFromInt(0x03275A10);
var NiRTTI_NiPSysEmitter: *const NiRTTI = @ptrFromInt(0x03275A20);
var NiRTTI_NiPSysModifierCtlr: *const NiRTTI = @ptrFromInt(0x03275A30);
var NiRTTI_NiPSysModifier: *const NiRTTI = @ptrFromInt(0x03275A48);
var NiRTTI_NiPSysMeshUpdateModifier: *const NiRTTI = @ptrFromInt(0x03275A58);
var NiRTTI_NiPSysUpdateCtlr: *const NiRTTI = @ptrFromInt(0x03275A68);
var NiRTTI_NiMeshPSysData: *const NiRTTI = @ptrFromInt(0x03275A78);
var NiRTTI_NiPSysAirFieldAirFrictionCtlr: *const NiRTTI = @ptrFromInt(0x03275A88);
var NiRTTI_NiPSysAirFieldInheritVelocityCtlr: *const NiRTTI = @ptrFromInt(0x03275A98);
var NiRTTI_NiPSysAirFieldModifier: *const NiRTTI = @ptrFromInt(0x03275AA8);
var NiRTTI_NiPSysAirFieldSpreadCtlr: *const NiRTTI = @ptrFromInt(0x03275AB8);
var NiRTTI_NiPSysAgeDeathModifier: *const NiRTTI = @ptrFromInt(0x03275AC8);
var NiRTTI_NiPSysBombModifier: *const NiRTTI = @ptrFromInt(0x03275AD8);
var NiRTTI_NiPSysBoundUpdateModifier: *const NiRTTI = @ptrFromInt(0x03275AE8);
var NiRTTI_NiPSysBoxEmitter: *const NiRTTI = @ptrFromInt(0x03275AF8);
var NiRTTI_NiPSysColliderManager: *const NiRTTI = @ptrFromInt(0x03275B08);
var NiRTTI_NiPSysColorModifier: *const NiRTTI = @ptrFromInt(0x03275B18);
var NiRTTI_NiPSysData: *const NiRTTI = @ptrFromInt(0x03275B28);
var NiRTTI_NiPSysDragFieldModifier: *const NiRTTI = @ptrFromInt(0x03275B38);
var NiRTTI_NiPSysDragModifier: *const NiRTTI = @ptrFromInt(0x03275B48);
var NiRTTI_NiPSysEmitterCtlrData: *const NiRTTI = @ptrFromInt(0x03275B58);
var NiRTTI_NiPSysEmitterDeclinationCtlr: *const NiRTTI = @ptrFromInt(0x03275B68);
var NiRTTI_NiPSysEmitterDeclinationVarCtlr: *const NiRTTI = @ptrFromInt(0x03275B78);
var NiRTTI_NiPSysEmitterInitialRadiusCtlr: *const NiRTTI = @ptrFromInt(0x03275B88);
var NiRTTI_NiPSysEmitterLifeSpanCtlr: *const NiRTTI = @ptrFromInt(0x03275B98);
var NiRTTI_NiPSysEmitterPlanarAngleCtlr: *const NiRTTI = @ptrFromInt(0x03275BA8);
var NiRTTI_NiPSysEmitterPlanarAngleVarCtlr: *const NiRTTI = @ptrFromInt(0x03275BB8);
var NiRTTI_NiPSysEmitterSpeedCtlr: *const NiRTTI = @ptrFromInt(0x03275BC8);
var NiRTTI_NiPSysFieldAttenuationCtlr: *const NiRTTI = @ptrFromInt(0x03275BD8);
var NiRTTI_NiPSysFieldMagnitudeCtlr: *const NiRTTI = @ptrFromInt(0x03275BE8);
var NiRTTI_NiPSysFieldMaxDistanceCtlr: *const NiRTTI = @ptrFromInt(0x03275BF8);
var NiRTTI_NiPSysGravityFieldModifier: *const NiRTTI = @ptrFromInt(0x03275C08);
var NiRTTI_NiPSysGravityStrengthCtlr: *const NiRTTI = @ptrFromInt(0x03275C18);
var NiRTTI_NiPSysGrowFadeModifier: *const NiRTTI = @ptrFromInt(0x03275C28);
var NiRTTI_NiPSysInitialRotAngleCtlr: *const NiRTTI = @ptrFromInt(0x03275C38);
var NiRTTI_NiPSysInitialRotAngleVarCtlr: *const NiRTTI = @ptrFromInt(0x03275C48);
var NiRTTI_NiPSysInitialRotSpeedCtlr: *const NiRTTI = @ptrFromInt(0x03275C58);
var NiRTTI_NiPSysInitialRotSpeedVarCtlr: *const NiRTTI = @ptrFromInt(0x03275C68);
var NiRTTI_NiPSysMeshEmitter: *const NiRTTI = @ptrFromInt(0x03275C78);
var NiRTTI_NiPSysModifierActiveCtlr: *const NiRTTI = @ptrFromInt(0x03275CA8);
var NiRTTI_NiPSysPlanarCollider: *const NiRTTI = @ptrFromInt(0x03275CB8);
var NiRTTI_NiPSysPositionModifier: *const NiRTTI = @ptrFromInt(0x03275CC8);
var NiRTTI_NiPSysRadialFieldModifier: *const NiRTTI = @ptrFromInt(0x03275CD8);
var NiRTTI_NiPSysResetOnLoopCtlr: *const NiRTTI = @ptrFromInt(0x03275CE8);
var NiRTTI_NiPSysRotationModifier: *const NiRTTI = @ptrFromInt(0x03275CF8);
var NiRTTI_NiPSysSpawnModifier: *const NiRTTI = @ptrFromInt(0x03275D08);
var NiRTTI_NiPSysSphereEmitter: *const NiRTTI = @ptrFromInt(0x03275D18);
var NiRTTI_NiPSysSphericalCollider: *const NiRTTI = @ptrFromInt(0x03275D28);
var NiRTTI_NiPSysTurbulenceFieldModifier: *const NiRTTI = @ptrFromInt(0x03275D38);
var NiRTTI_NiPSysVortexFieldModifier: *const NiRTTI = @ptrFromInt(0x03275D48);
var NiRTTI_BSStripPSysData: *const NiRTTI = @ptrFromInt(0x03275D58);
var NiRTTI_BSPSysRecycleBoundModifier: *const NiRTTI = @ptrFromInt(0x03275D70);
var NiRTTI_BSPSysInheritVelocityModifier: *const NiRTTI = @ptrFromInt(0x03275D80);
var NiRTTI_NiPSysVolumeEmitter: *const NiRTTI = @ptrFromInt(0x03275D90);
var NiRTTI_NiPSysModifierFloatCtlr: *const NiRTTI = @ptrFromInt(0x03275DA0);
var NiRTTI_NiPSysFieldModifier: *const NiRTTI = @ptrFromInt(0x03275DB0);
var NiRTTI_NiPSysModifierBoolCtlr: *const NiRTTI = @ptrFromInt(0x03275DC0);
var NiRTTI_NiPSysCollider: *const NiRTTI = @ptrFromInt(0x03275DD0);
var NiRTTI_BSMultiBound: *const NiRTTI = @ptrFromInt(0x0327E088);
var NiRTTI_BSMultiBoundRoom: *const NiRTTI = @ptrFromInt(0x0327E098);
var NiRTTI_BSMultiBoundAABB: *const NiRTTI = @ptrFromInt(0x0327E0B0);
var NiRTTI_BSMultiBoundOBB: *const NiRTTI = @ptrFromInt(0x0327E0C8);
var NiRTTI_BSXFlags: *const NiRTTI = @ptrFromInt(0x0327E0E8);
var NiRTTI_BSValueNode: *const NiRTTI = @ptrFromInt(0x0327E100);
var NiRTTI_BSWindModifier: *const NiRTTI = @ptrFromInt(0x03284680);
var NiRTTI_BSTempNodeManager: *const NiRTTI = @ptrFromInt(0x032846A0);
var NiRTTI_BSTempNode: *const NiRTTI = @ptrFromInt(0x032846B0);
var NiRTTI_BSOcclusionShape: *const NiRTTI = @ptrFromInt(0x032846D0);
var NiRTTI_BSRangeNode: *const NiRTTI = @ptrFromInt(0x032847C8);
var NiRTTI_BSBlastNode: *const NiRTTI = @ptrFromInt(0x03284A00);
var NiRTTI_BSDebrisNode: *const NiRTTI = @ptrFromInt(0x03284A10);
var NiRTTI_BSDamageStage: *const NiRTTI = @ptrFromInt(0x03284A20);
var NiRTTI_BSPSysArrayEmitter: *const NiRTTI = @ptrFromInt(0x03284A30);
var NiRTTI_PArrayPoint: *const NiRTTI = @ptrFromInt(0x03284A40);
var NiRTTI_BSMultiStreamInstanceTriShape: *const NiRTTI = @ptrFromInt(0x03284A68);
var NiRTTI_BSMultiBoundShape: *const NiRTTI = @ptrFromInt(0x03284A98);
var NiRTTI_BSMultiBoundSphere: *const NiRTTI = @ptrFromInt(0x03284AA8);
var NiRTTI_BSOcclusionBox: *const NiRTTI = @ptrFromInt(0x03284AC0);
var NiRTTI_BSOcclusionPlane: *const NiRTTI = @ptrFromInt(0x03284AD8);
var NiRTTI_BSPortal: *const NiRTTI = @ptrFromInt(0x03284AE8);
var NiRTTI_BSPortalSharedNode: *const NiRTTI = @ptrFromInt(0x03284AF8);
var NiRTTI_BSBodyMorphOffsetsExtraData: *const NiRTTI = @ptrFromInt(0x03284B10);
var NiRTTI_BSBehaviorGraphExtraData: *const NiRTTI = @ptrFromInt(0x03284B20);
var NiRTTI_NiBSBoneLODController: *const NiRTTI = @ptrFromInt(0x03284B38);
var NiRTTI_BSCullingProcess: *const NiRTTI = @ptrFromInt(0x03284B58);
var NiRTTI_BSParticleSystemManager: *const NiRTTI = @ptrFromInt(0x03284B78);
var NiRTTI_BSFurnitureMarkerNode: *const NiRTTI = @ptrFromInt(0x03284BA0);
var NiRTTI_BSBound: *const NiRTTI = @ptrFromInt(0x03284C20);
var NiRTTI_BSMultiBoundNode: *const NiRTTI = @ptrFromInt(0x03284C40);
var NiRTTI_BSBoneMap: *const NiRTTI = @ptrFromInt(0x03284C50);
var NiRTTI_BSAnimInteractionMarker: *const NiRTTI = @ptrFromInt(0x03284C68);
var NiRTTI_BSSceneGraph: *const NiRTTI = @ptrFromInt(0x03284C80);
var NiRTTI_BSPSysMultiTargetEmitterCtlr: *const NiRTTI = @ptrFromInt(0x03284C98);
var NiRTTI_BSGeometryListCullingProcess: *const NiRTTI = @ptrFromInt(0x03284CB0);
var NiRTTI_BSSubIndexTriShape: *const NiRTTI = @ptrFromInt(0x03284CC8);
var NiRTTI_BSDistantObjectLargeRefExtraData: *const NiRTTI = @ptrFromInt(0x03284CD8);
var NiRTTI_BSMasterParticleSystem: *const NiRTTI = @ptrFromInt(0x032866A0);
var NiRTTI_BSProceduralLightningController: *const NiRTTI = @ptrFromInt(0x032866C8);
var NiRTTI_BSInvMarker: *const NiRTTI = @ptrFromInt(0x032866D8);
var NiRTTI_BSBoneLODExtraData: *const NiRTTI = @ptrFromInt(0x032866F0);
var NiRTTI_BSReference: *const NiRTTI = @ptrFromInt(0x03286710);
var NiRTTI_BSNodeReferences: *const NiRTTI = @ptrFromInt(0x03286720);
var NiRTTI_BSDecalPlacementVectorExtraData: *const NiRTTI = @ptrFromInt(0x03286730);
var NiRTTI_BSParentVelocityModifier: *const NiRTTI = @ptrFromInt(0x03286740);
var NiRTTI_BSWArray: *const NiRTTI = @ptrFromInt(0x03286750);
var NiRTTI_BSMultiBoundCapsule: *const NiRTTI = @ptrFromInt(0x03286768);
var NiRTTI_BSPSysStripUpdateModifier: *const NiRTTI = @ptrFromInt(0x03286778);
var NiRTTI_BSPSysSubTexModifier: *const NiRTTI = @ptrFromInt(0x03286788);
var NiRTTI_BSPSysScaleModifier: *const NiRTTI = @ptrFromInt(0x03286798);
var NiRTTI_BSLagBoneController: *const NiRTTI = @ptrFromInt(0x032867A8);
var NiRTTI_BSNonUniformScaleExtraData: *const NiRTTI = @ptrFromInt(0x032867B8);
var NiRTTI_BSNiNode: *const NiRTTI = @ptrFromInt(0x032867D0);
var NiRTTI_BSInstanceTriShape: *const NiRTTI = @ptrFromInt(0x032867E0);
var NiRTTI_bhkWorldObject: *const NiRTTI = @ptrFromInt(0x0328CD68);
var NiRTTI_bhkWorld: *const NiRTTI = @ptrFromInt(0x0328CDA8);
var NiRTTI_bhkRigidBody: *const NiRTTI = @ptrFromInt(0x0328DEE8);
var NiRTTI_bhkCollisionObject: *const NiRTTI = @ptrFromInt(0x0328DF00);
var NiRTTI_bhkNiCollisionObject: *const NiRTTI = @ptrFromInt(0x0328DFB0);
var NiRTTI_bhkAttachmentCollisionObject: *const NiRTTI = @ptrFromInt(0x0328E030);
var NiRTTI_WeaponObject: *const NiRTTI = @ptrFromInt(0x0328E040);
var NiRTTI_bhkRigidBodyT: *const NiRTTI = @ptrFromInt(0x0328E068);
var NiRTTI_bhkWorldM: *const NiRTTI = @ptrFromInt(0x0328E078);
var NiRTTI_bhkRefObject: *const NiRTTI = @ptrFromInt(0x0328E0A0);
var NiRTTI_bhkSerializable: *const NiRTTI = @ptrFromInt(0x0328E0B0);
var NiRTTI_bhkShape: *const NiRTTI = @ptrFromInt(0x0328E0E0);
var NiRTTI_bhkEntity: *const NiRTTI = @ptrFromInt(0x0328E0F8);
var NiRTTI_bhkPhantom: *const NiRTTI = @ptrFromInt(0x0328E110);
var NiRTTI_bhkAabbPhantom: *const NiRTTI = @ptrFromInt(0x0328E128);
var NiRTTI_bhkSphereRepShape: *const NiRTTI = @ptrFromInt(0x0328E140);
var NiRTTI_bhkConvexShape: *const NiRTTI = @ptrFromInt(0x0328E158);
var NiRTTI_bhkPCollisionObject: *const NiRTTI = @ptrFromInt(0x0328E168);
var NiRTTI_hkPackedNiTriStripsData: *const NiRTTI = @ptrFromInt(0x0328E178);
var NiRTTI_bhkShapePhantom: *const NiRTTI = @ptrFromInt(0x0328E190);
var NiRTTI_bhkSimpleShapePhantom: *const NiRTTI = @ptrFromInt(0x0328E1A8);
var NiRTTI_bhkCapsuleShape: *const NiRTTI = @ptrFromInt(0x0328E1C0);
var NiRTTI_bhkBoxShape: *const NiRTTI = @ptrFromInt(0x0328E1D8);
var NiRTTI_bhkSphereShape: *const NiRTTI = @ptrFromInt(0x0328E1F0);
var NiRTTI_bhkBvTreeShape: *const NiRTTI = @ptrFromInt(0x0328E208);
var NiRTTI_bhkNiTriStripsShape: *const NiRTTI = @ptrFromInt(0x0328E220);
var NiRTTI_bhkPackedNiTriStripsShape: *const NiRTTI = @ptrFromInt(0x0328E248);
var NiRTTI_bhkBlendCollisionObject: *const NiRTTI = @ptrFromInt(0x0328E260);
var NiRTTI_bhkAvoidBox: *const NiRTTI = @ptrFromInt(0x0328E280);
var NiRTTI_bhkLimitedHingeConstraint: *const NiRTTI = @ptrFromInt(0x0328E298);
var NiRTTI_bhkMalleableConstraint: *const NiRTTI = @ptrFromInt(0x0328E2B0);
var NiRTTI_bhkUnaryAction: *const NiRTTI = @ptrFromInt(0x0328E2C8);
var NiRTTI_bhkConstraint: *const NiRTTI = @ptrFromInt(0x0328E2E0);
var NiRTTI_bhkPrismaticConstraint: *const NiRTTI = @ptrFromInt(0x0328E2F8);
var NiRTTI_bhkAction: *const NiRTTI = @ptrFromInt(0x0328E310);
var NiRTTI_bhkTriSampledHeightFieldBvTreeShape: *const NiRTTI = @ptrFromInt(0x0328E328);
var NiRTTI_bhkCachingShapePhantom: *const NiRTTI = @ptrFromInt(0x0328EF98);
var NiRTTI_bhkRagdollTemplateData: *const NiRTTI = @ptrFromInt(0x0328EFC0);
var NiRTTI_bhkRagdollTemplate: *const NiRTTI = @ptrFromInt(0x0328EFD0);
var NiRTTI_bhkSPCollisionObject: *const NiRTTI = @ptrFromInt(0x0328EFE0);
var NiRTTI_bhkMouseSpringAction: *const NiRTTI = @ptrFromInt(0x0328EFF8);
var NiRTTI_bhkHingeConstraint: *const NiRTTI = @ptrFromInt(0x0328F010);
var NiRTTI_bhkCompressedMeshShape: *const NiRTTI = @ptrFromInt(0x0328F088);
var NiRTTI_bhkCompressedMeshShapeData: *const NiRTTI = @ptrFromInt(0x0328F098);
var NiRTTI_bhkConvexSweepShape: *const NiRTTI = @ptrFromInt(0x0328F0B0);
var NiRTTI_bhkConvexTransformShape: *const NiRTTI = @ptrFromInt(0x0328F0C8);
var NiRTTI_bhkConvexTranslateShape: *const NiRTTI = @ptrFromInt(0x0328F0E0);
var NiRTTI_bhkConvexVerticesShape: *const NiRTTI = @ptrFromInt(0x0328F0F8);
var NiRTTI_bhkCylinderShape: *const NiRTTI = @ptrFromInt(0x0328F110);
var NiRTTI_bhkMultiSphereShape: *const NiRTTI = @ptrFromInt(0x0328F128);
var NiRTTI_bhkPlaneShape: *const NiRTTI = @ptrFromInt(0x0328F140);
var NiRTTI_bhkTriangleShape: *const NiRTTI = @ptrFromInt(0x0328F158);
var NiRTTI_bhkMoppBvTreeShape: *const NiRTTI = @ptrFromInt(0x0328F170);
var NiRTTI_bhkTransformShape: *const NiRTTI = @ptrFromInt(0x0328F188);
var NiRTTI_bhkListShape: *const NiRTTI = @ptrFromInt(0x0328F1A0);
var NiRTTI_bhkBallAndSocketConstraint: *const NiRTTI = @ptrFromInt(0x0328F1B8);
var NiRTTI_bhkBallSocketConstraintChain: *const NiRTTI = @ptrFromInt(0x0328F1D0);
var NiRTTI_bhkGroupConstraint: *const NiRTTI = @ptrFromInt(0x0328F1E8);
var NiRTTI_bhkHingeLimitsConstraint: *const NiRTTI = @ptrFromInt(0x0328F200);
var NiRTTI_bhkFixedConstraint: *const NiRTTI = @ptrFromInt(0x0328F218);
var NiRTTI_bhkRagdollConstraint: *const NiRTTI = @ptrFromInt(0x0328F230);
var NiRTTI_bhkRagdollLimitsConstraint: *const NiRTTI = @ptrFromInt(0x0328F248);
var NiRTTI_bhkStiffSpringConstraint: *const NiRTTI = @ptrFromInt(0x0328F260);
var NiRTTI_bhkWheelConstraint: *const NiRTTI = @ptrFromInt(0x0328F278);
var NiRTTI_bhkBreakableConstraint: *const NiRTTI = @ptrFromInt(0x0328F290);
var NiRTTI_bhkAngularDashpotAction: *const NiRTTI = @ptrFromInt(0x0328F2A8);
var NiRTTI_bhkDashpotAction: *const NiRTTI = @ptrFromInt(0x0328F2C0);
var NiRTTI_bhkLiquidAction: *const NiRTTI = @ptrFromInt(0x0328F2D8);
var NiRTTI_bhkMotorAction: *const NiRTTI = @ptrFromInt(0x0328F2F8);
var NiRTTI_bhkOrientHingedBodyAction: *const NiRTTI = @ptrFromInt(0x0328F310);
var NiRTTI_bhkSpringAction: *const NiRTTI = @ptrFromInt(0x0328F328);
var NiRTTI_bhkBlendController: *const NiRTTI = @ptrFromInt(0x0328F338);
var NiRTTI_bhkExtraData: *const NiRTTI = @ptrFromInt(0x0328F348);
var NiRTTI_bhkPoseArray: *const NiRTTI = @ptrFromInt(0x0328F358);
var NiRTTI_bhkGenericConstraint: *const NiRTTI = @ptrFromInt(0x0328F378);
var NiRTTI_bhkCharControllerShape: *const NiRTTI = @ptrFromInt(0x0328F388);
var NiRTTI_bhkCollisionBox: *const NiRTTI = @ptrFromInt(0x0328F3A0);
var NiRTTI_bhkShapeCollection: *const NiRTTI = @ptrFromInt(0x0328F3B8);
var NiRTTI_bhkPositionConstraintMotor: *const NiRTTI = @ptrFromInt(0x0328F420);
var NiRTTI_bhkVelocityConstraintMotor: *const NiRTTI = @ptrFromInt(0x0328F430);
var NiRTTI_bhkSpringDamperConstraintMotor: *const NiRTTI = @ptrFromInt(0x0328F440);
var NiRTTI_bhkCharacterProxy: *const NiRTTI = @ptrFromInt(0x032901F8);
var NiRTTI_bhkCharacterRigidBody: *const NiRTTI = @ptrFromInt(0x03290210);
var NiRTTI_bhkHeightFieldShape: *const NiRTTI = @ptrFromInt(0x03291518);
var NiRTTI_bhkConstraintChain: *const NiRTTI = @ptrFromInt(0x03291530);
var NiRTTI_bhkBinaryAction: *const NiRTTI = @ptrFromInt(0x03291548);
var NiRTTI_bhkPointToPathConstraint: *const NiRTTI = @ptrFromInt(0x03291580);
var NiRTTI_DebugTextExtraData: *const NiRTTI = @ptrFromInt(0x03292D90);
var NiRTTI_BSFadeNode: *const NiRTTI = @ptrFromInt(0x0332A288);
var NiRTTI_BSShaderProperty: *const NiRTTI = @ptrFromInt(0x0332A2B8);
var NiRTTI_BSLeafAnimNode: *const NiRTTI = @ptrFromInt(0x0332A2C8);
var NiRTTI_BSTreeNode: *const NiRTTI = @ptrFromInt(0x0332A2D8);
var NiRTTI_ShadowSceneNode: *const NiRTTI = @ptrFromInt(0x0332A700);
var NiRTTI_BSLightingShaderProperty: *const NiRTTI = @ptrFromInt(0x0332AFD0);
var NiRTTI_BSGrassShaderProperty: *const NiRTTI = @ptrFromInt(0x0332B008);
var NiRTTI_BSShaderAccumulator: *const NiRTTI = @ptrFromInt(0x0332B220);
var NiRTTI_BSEffectShaderProperty: *const NiRTTI = @ptrFromInt(0x0332B3C0);
var NiRTTI_BSWaterShaderProperty: *const NiRTTI = @ptrFromInt(0x0338C1E8);
var NiRTTI_BSBloodSplatterShaderProperty: *const NiRTTI = @ptrFromInt(0x0338C1F8);
var NiRTTI_BSParticleShaderProperty: *const NiRTTI = @ptrFromInt(0x0338C5E8);
var NiRTTI_BSTextureSet: *const NiRTTI = @ptrFromInt(0x0338C938);
var NiRTTI_BSShaderTextureSet: *const NiRTTI = @ptrFromInt(0x0338C948);
var NiRTTI_BSSkyShaderProperty: *const NiRTTI = @ptrFromInt(0x0338CC48);
var NiRTTI_BSFadeNodeCuller: *const NiRTTI = @ptrFromInt(0x033DCCD0);
var NiRTTI_BSDistantTreeShaderProperty: *const NiRTTI = @ptrFromInt(0x033DCD00);
var NiRTTI_BSCubeMapCamera: *const NiRTTI = @ptrFromInt(0x033DCEE0);
var NiRTTI_BSFogProperty: *const NiRTTI = @ptrFromInt(0x033DCF98);
var NiRTTI_BSClearZNode: *const NiRTTI = @ptrFromInt(0x035EF058);
var NiRTTI_NiCollisionObject: *const NiRTTI = @ptrFromInt(0x035EF178);
var NiRTTI_BSOrderedNode: *const NiRTTI = @ptrFromInt(0x035EF188);
var NiRTTI_BSLines: *const NiRTTI = @ptrFromInt(0x035EF198);
var NiRTTI_BSDynamicLines: *const NiRTTI = @ptrFromInt(0x035EF1A8);
var NiRTTI_BSMultiIndexTriShape: *const NiRTTI = @ptrFromInt(0x035EF1C8);
var NiRTTI_BSLightingShaderPropertyFloatController: *const NiRTTI = @ptrFromInt(0x035EF270);
var NiRTTI_BSLightingShaderPropertyUShortController: *const NiRTTI = @ptrFromInt(0x035EF288);
var NiRTTI_BSLightingShaderPropertyColorController: *const NiRTTI = @ptrFromInt(0x035EF2A0);
var NiRTTI_BSEffectShaderPropertyFloatController: *const NiRTTI = @ptrFromInt(0x035EF2D8);
var NiRTTI_BSEffectShaderPropertyColorController: *const NiRTTI = @ptrFromInt(0x035EF2F0);
var NiRTTI_BSNiAlphaPropertyTestRefController: *const NiRTTI = @ptrFromInt(0x035EF300);
var NiRTTI_BSPSysSimpleColorModifier: *const NiRTTI = @ptrFromInt(0x035EF310);
var NiRTTI_BSPSysLODModifier: *const NiRTTI = @ptrFromInt(0x035EF320);
var NiRTTI_BSParabolicCullingProcess: *const NiRTTI = @ptrFromInt(0x035EF7A8);
var NiRTTI_BSMeshLODTriShape: *const NiRTTI = @ptrFromInt(0x035EF7B8);
var NiRTTI_BSLODMultiIndexTriShape: *const NiRTTI = @ptrFromInt(0x035EF7C8);
var NiRTTI_BSSubIndexLandTriShape: *const NiRTTI = @ptrFromInt(0x035EF7E0);
