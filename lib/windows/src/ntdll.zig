const stdwin = @import("std").os.windows;
const windows = @import("windows.zig");

const ULONG = windows.ULONG;
const DWORD = windows.DWORD;
const HANDLE = windows.HANDLE;
const ACCESS_MASK = windows.ACCESS_MASK;
const LPVOID = windows.LPVOID;
const PVOID = windows.PVOID;
const SIZE_T = windows.SIZE_T;
const NTSTATUS = windows.NTSTATUS;
const BOOLEAN = windows.BOOLEAN;
const OBJECT_ATTRIBUTES = windows.OBJECT_ATTRIBUTES;
const Win32Error = windows.Win32Error;
const ULONG_PTR = windows.ULONG_PTR;
const CLIENT_ID = windows.CLIENT_ID;
const PAGE = windows.PAGE;
pub const USER_THREAD_START_ROUTINE = fn (LPVOID) callconv(.winapi) NTSTATUS;
pub const PUSER_THREAD_START_ROUTINE = *const USER_THREAD_START_ROUTINE;
const POBJECT_ATTRIBUTES = *const OBJECT_ATTRIBUTES;
const PCLIENT_ID = *const CLIENT_ID;
const PWSTR = windows.PWSTR;
const UNICODE_STRING = windows.UNICODE_STRING;

const MEMORY_INFORMATION_CLASS = enum(DWORD) {
    MemoryBasicInformation = 0, // q: MEMORY_BASIC_INFORMATION
    MemoryWorkingSetInformation, // q: MEMORY_WORKING_SET_INFORMATION
    MemoryMappedFilenameInformation, // q: UNICODE_STRING
    MemoryRegionInformation, // q: MEMORY_REGION_INFORMATION
    MemoryWorkingSetExInformation, // q: MEMORY_WORKING_SET_EX_INFORMATION // since VISTA
    MemorySharedCommitInformation, // q: MEMORY_SHARED_COMMIT_INFORMATION // since WIN8
    MemoryImageInformation, // q: MEMORY_IMAGE_INFORMATION
    MemoryRegionInformationEx, // q: MEMORY_REGION_INFORMATION
    MemoryPrivilegedBasicInformation, // q: MEMORY_BASIC_INFORMATION
    MemoryEnclaveImageInformation, // q: MEMORY_ENCLAVE_IMAGE_INFORMATION // since REDSTONE3
    MemoryBasicInformationCapped, // q: 10
    MemoryPhysicalContiguityInformation, // q: MEMORY_PHYSICAL_CONTIGUITY_INFORMATION // since 20H1
    MemoryBadInformation, // q: MEMORY_BAD_INFORMATION // since WIN11
    MemoryBadInformationAllProcesses, // qs: not implemented // since 22H1
    MemoryImageExtensionInformation, // q: MEMORY_IMAGE_EXTENSION_INFORMATION // since 24H2
    MaxMemoryInfoClass,
};

pub const THREAD_CREATE_FLAGS = packed struct(u32) {
    CREATE_SUSPENDED: bool = false,
    SKIP_THREAD_ATTACH: bool = false, // Ex only
    HIDE_FROM_DEBUGGER: bool = false, // Ex only
    _reserved1: u1 = 0, // Ex only
    LOADER_WORKER: bool = false, // Ex only, since THRESHOLD
    SKIP_LOADER_INIT: bool = false, // Ex only, since REDSTONE2
    BYPASS_PROCESS_FREEZE: bool = false, // Ex only, since 19H1
    _reserved2: u25 = 0,
};

pub const PS_ATTRIBUTE_LIST = extern struct {
    TotalLength: SIZE_T,
    Attributes: [0]Entry,

    const List = @This();

    pub const PS_ATTRIBUTE = enum(usize) {
        pub const NUM = enum(u16) {
            ParentProcess = 0,
            DebugObject = 1,
            Token = 2,
            ClientId = 3,
            TebAddress = 4,
            ImageName = 5,
            ImageInfo = 6,
            MemoryReserve = 7,
            PriorityClass = 8,
            ErrorMode = 9,
            StdHandleInfo = 10,
            HandleList = 11,
            GroupAffinity = 12,
            PreferredNode = 13,
            IdealProcessor = 14,
            UmsThread = 15,
            MitigationOptions = 16,
            ProtectionLevel = 17,
            SecureProcess = 18,
            JobList = 19,
            ChildProcessPolicy = 20,
            AllApplicationPackagesPolicy = 21,
            Win32kFilter = 22,
            SafeOpenPromptOriginClaim = 23,
            BnoIsolation = 24,
            DesktopAppPolicy = 25,
            Chpe = 26,
            MitigationAuditOptions = 27,
            MachineType = 28,
            ComponentFilter = 29,
            EnableOptionalXStateFeatures = 30,
            SupportedMachines = 31,
            SveVectorLength = 32,
            Max,
        };

        pub const Bits = packed struct(usize) {
            num: u16,
            thread: bool,
            input: bool,
            additive: bool,
            _reserved: u45,
            pub fn init(num: NUM, thread: bool, input: bool, additive: bool) Bits {
                return .{
                    .num = @intFromEnum(num),
                    .thread = thread,
                    .input = input,
                    .additive = additive,
                    ._reserved = 0,
                };
            }
            pub fn asValue(self: Bits) usize {
                const v: usize = @bitCast(self);
                return v;
            }
        };

        pub fn value(num: NUM, thread: bool, input: bool, additive: bool) usize {
            return Bits.init(num, thread, input, additive).asValue();
        }

        PARENT_PROCESS = value(.ParentProcess, false, true, true),
        DEBUG_OBJECT = value(.DebugObject, false, true, true),
        TOKEN = value(.Token, false, true, true),
        CLIENT_ID = value(.ClientId, true, false, false),
        TEBA_ADDRESS = value(.TebAddress, true, false, false),
        IMAGE_NAME = value(.ImageName, false, true, false),
        IMAGE_INFO = value(.ImageInfo, false, false, false),
        MEMORY_RESERVE = value(.MemoryReserve, false, true, false),
        PRIORITY_CLASS = value(.PriorityClass, false, true, false),
        ERROR_MODE = value(.ErrorMode, false, true, false),
        STD_HANDLE_INFO = value(.StdHandleInfo, false, true, false),
        HANDLE_LIST = value(.HandleList, false, true, false),
        GROUP_AFFINITY = value(.GroupAffinity, true, true, false),
        PREFERRED_NODE = value(.PreferredNode, false, true, false),
        IDEAL_PROCESSOR = value(.IdealProcessor, true, true, false),
        UMS_THREAD = value(.UmsThread, true, true, false),
        MITIGATION_OPTIONS = value(.MitigationOptions, false, true, false),
        PROTECTION_LEVEL = value(.ProtectionLevel, false, true, true),
        SECURE_PROCESS = value(.SecureProcess, false, true, false),
        JOB_LIST = value(.JobList, false, true, false),
        CHILD_PROCESS_POLICY = value(.ChildProcessPolicy, false, true, false),
        ALL_APPLICATION_PACKAGES_POLICY = value(.AllApplicationPackagesPolicy, false, true, false),
        WIN32K_FILTER = value(.Win32kFilter, false, true, false),
        SAFE_OPEN_PROMPT_ORIGIN_CLAIM = value(.SafeOpenPromptOriginClaim, false, true, false),
        BNO_ISOLATION = value(.BnoIsolation, false, true, false),
        DESKTOP_APP_POLICY = value(.DesktopAppPolicy, false, true, false),
        CHPE = value(.Chpe, false, true, true),
        MITIGATION_AUDIT_OPTIONS = value(.MitigationAuditOptions, false, true, false),
        MACHINE_TYPE = value(.MachineType, false, true, true),
        COMPONENT_FILTER = value(.ComponentFilter, false, true, false),
        ENABLE_OPTIONAL_XSTATE_FEATURES = value(.EnableOptionalXStateFeatures, true, true, false),
        //SUPPORTED_MACHINES, // Unknown
        //SVE_VECTOR_LENGTH, // Unknown
    };

    const Entry = extern struct {
        Attribute: PS_ATTRIBUTE,
        Size: SIZE_T,
        Data: extern union {
            value: ULONG_PTR,
            ptr: PVOID,
        },
        ReturnLength: ?*SIZE_T,
    };

    pub fn Buffer(len: usize) type {
        return extern struct {
            list: List,
            entries: [len]Entry,

            const Self = @This();
            pub fn init() Self {
                var self: Self = undefined;
                self.list.TotalLength = @sizeOf(List) + len * @sizeOf(Entry);
                for (&self.entries) |*entry| {
                    entry.* = .{
                        .Attribute = undefined,
                        .Size = 0,
                        .Data = undefined,
                        .ReturnLength = null,
                    };
                }
                return self;
            }
            pub fn asList(self: *Self) *List {
                return @ptrCast(self);
            }
        };
    }
};

pub extern "ntdll" fn NtCreateThreadEx(
    ThreadHandle: *HANDLE,
    DesiredAccess: ACCESS_MASK,
    ObjectAttributes: ?*OBJECT_ATTRIBUTES,
    ProcessHandle: HANDLE,
    StartRoutine: PUSER_THREAD_START_ROUTINE,
    Argument: ?PVOID,
    CreateFlags: THREAD_CREATE_FLAGS,
    ZeroBits: SIZE_T,
    StackSize: SIZE_T,
    MaximumStackSize: SIZE_T,
    AttributeList: ?*PS_ATTRIBUTE_LIST,
) callconv(.winapi) NTSTATUS;

pub extern "ntdll" fn RtlNtStatusToDosError(
    Status: NTSTATUS,
) callconv(.winapi) Win32Error;

pub extern "ntdll" fn RtlSetLastWin32Error(err: Win32Error) callconv(.winapi) void;

pub extern "ntdll" fn RtlFlushSecureMemoryCache(
    MemoryCache: PVOID,
    MemoryLength: SIZE_T,
) callconv(.winapi) BOOLEAN;

pub extern "ntdll" fn NtOpenProcess(
    ProcessHandle: *HANDLE,
    DesiredAccess: ACCESS_MASK,
    ObjectAttributes: POBJECT_ATTRIBUTES,
    ClientId: ?PCLIENT_ID,
) callconv(.winapi) NTSTATUS;

pub extern "ntdll" fn NtProtectVirtualMemory(
    ProcessHandle: HANDLE,
    BaseAddress: *?PVOID,
    NumberOfBytesToProtect: *SIZE_T,
    NewAccessProtection: PAGE,
    OldAccessProtection: *PAGE,
) callconv(.winapi) NTSTATUS;

pub extern "ntdll" fn NtQueryVirtualMemory(
    ProcessHandle: HANDLE,
    BaseAddress: PVOID,
    MemInfoClass: MEMORY_INFORMATION_CLASS,
    MemInfo: PVOID,
    MemInfoLen: SIZE_T,
    ReturnLength: ?*SIZE_T,
) NTSTATUS;
const PCWSTR = windows.PCWSTR;

pub extern "ntdll" fn LdrLoadDll(
    DllPath: ?PCWSTR,
    DllCharacteristics: ?*ULONG,
    DllName: *const UNICODE_STRING,
    DllHandle: *PVOID,
) callconv(.winapi) NTSTATUS;

pub extern "ntdll" fn LdrGetDllPath(
    DllName: PCWSTR,
    Flags: ULONG, // LOAD_LIBRARY_SEARCH_*
    DllPath: *PWSTR,
    SearchPaths: *PWSTR,
) callconv(.winapi) NTSTATUS;

pub extern "ntdll" fn RtlReleasePath(Path: PCWSTR) callconv(.winapi) void;

pub extern "ntdll" fn LdrGetDllHandle(
    DllPath: ?PCWSTR,
    DllCharacteristics: ?*ULONG,
    DllName: *UNICODE_STRING,
    DllHandle: *PVOID,
) callconv(.winapi) NTSTATUS;
