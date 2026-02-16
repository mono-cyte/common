// 10
/// NiRect 矩形
pub fn NiRect(T: type) type {
    return extern struct {
        m_left: T, // 00
        m_right: T, // 04
        m_top: T, // 08
        m_bottom: T, // 0C
    };
}
