// 10
/// NiQuaternion 四元数
pub const NiQuaternion = extern struct {
    // w is first
    m_fW: f32, // 0
    m_fX: f32, // 4
    m_fY: f32, // 8
    m_fZ: f32, // C
};
