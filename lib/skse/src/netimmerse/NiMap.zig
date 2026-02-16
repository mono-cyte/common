// 20
// derives from NiTMapBase, we don't bother
pub fn NiTMap(comptime K: type, comptime V: type) type {
    return extern struct {
        vtable: *const VTable, // 00
        numBuckets: u32, // 08
        _unk0C: u32, // 0C - 推测: 扩容阈值 (threshold = numBuckets * loadFactor)
        buckets: [*]?*NiTMapItem, // 10 - 桶数组指针
        numEntries: u32, // 18
        _unk1C: u32, // 1C - 推测: 修改计数 (modCount) 或 负载因子整数表示

        const Self = @This();
        pub const VTable = extern struct {
            _destructor: *const fn (self: *Self) callconv(.C) void,
            getBucket: *const fn (self: *const Self, key: K) callconv(.C) u32, // return hash % numBuckets;
            compare: *const fn (self: *const Self, lhs: K, rhs: K) callconv(.C) bool, // return lhs == rhs;
            fillItem: *const fn (self: *const Self, item: *NiTMapItem, key: K, data: V) callconv(.C) void,
            _Fn_04: *const fn (self: *const Self, arg: u32) callconv(.C) void, // nop
            allocItem: *const fn (self: *Self) callconv(.C) *NiTMapItem, // return new NiTMapItem;
            freeItem: *const fn (self: *Self, item: *NiTMapItem) callconv(.C) void, // item->data = 0; delete item;
        };

        pub const NiTMapItem = extern struct {
            next: ?*NiTMapItem,
            key: K,
            data: V,
        };

        pub fn get(self: *const Self, key: K) ?V {
            const bucket = self.vtable.getBucket(self, key);
            var current = self.buckets[bucket]; // ?*NiTMapItem
            while (current) |item| : (current = item.next) {
                if (self.vtable.compare(self, item.key, key)) {
                    return item.data;
                }
            } else {
                return null;
            }
        }
    };
}

// 继承自 NiTMap
pub fn NiTPointerMap(comptime K: type, comptime V: type) type {
    return NiTMap(K, V);
}
