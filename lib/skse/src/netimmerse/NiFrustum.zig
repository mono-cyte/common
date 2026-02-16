// 1C
/// NiFrustum 视锥体
pub const NiFrustum = extern struct {
    m_fLeft: f32, // 00
    m_fRight: f32, // 04
    m_fTop: f32, // 08
    m_fBottom: f32, // 0C
    m_fNear: f32, // 10
    m_fFar: f32, // 14
    m_bOrtho: bool, // 18
};
