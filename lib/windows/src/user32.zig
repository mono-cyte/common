const windows = @import("windows.zig");

const HWND = windows.HWND;
const LPCWSTR = windows.LPCWSTR;
const UINT = windows.UINT;
const WORD = windows.WORD;
const DWORD = windows.DWORD;

// int gfEMIEnable
var gfEMIEnable: i32 = 0;

// 存储当前持有 EMI 锁的线程 ID
var gdwEMIThreadID: usize = 0;

// void *gpReturnAddr
var gpReturnAddr: usize = 0;

const MessageBoxReturn = enum(i32) {
    Error = 0,
    IDOK = 1,
    IDCANCEL = 2,
    IDABORT = 3,
    IDRETRY = 4,
    IDIGNORE = 5,
    IDYES = 6,
    IDNO = 7,
    IDTRYAGAIN = 10,
    IDCONTINUE = 11,
};

const MessageBoxType = packed struct(u32) {
    BTN: enum(u4) {
        OK = 0,
        OKCANCEL = 1,
        ABORTRETRYIGNORE = 2,
        YESNOCANCEL = 3,
        YESNO = 4,
        RETRYCANCEL = 5,
        CANCELTRYCONTINUE = 6,
    },
    ICON: enum(u4) {
        HAND = 1, // HAND ERROR STOP
        QUESTION = 2,
        EXCLAMATION = 3, // EXCLAMATION WARNING
        ASTERISK = 4, // ASTERISK INFORMATION
    },
    DEFBTN: enum(u4) {
        DEFBUTTON1 = 0,
        DEFBUTTON2 = 1,
        DEFBUTTON3 = 2,
        DEFBUTTON4 = 3,
    },
    MODAL: enum(u2) {
        APPLMODAL = 0,
        SYSTEMMODAL = 1,
        TASKMODAL = 2,
    },
    HELP: bool,
    NOFOCUS: bool,
    SETFOREGROUND: bool,
    DEFAULT_DESKTOP_ONLY: bool,
    TOPMOST: bool,
    RIGHT: bool,
    RTLREADING: bool,
    SERVICE_NOTIFICATION: bool,
    _reserved1: bool,
    _reserved2: bool,
    _reserved3: u8,
};

pub fn MessageBoxW(
    hWnd: ?windows.HWND,
    lpText: ?windows.LPCWSTR,
    lpCaption: ?windows.LPCWSTR,
    uType: MessageBoxType,
) callconv(.winapi) i32 {
    if (@atomicLoad(i32, &gfEMIEnable, .seq_cst) != 0) {
        const tid = windows.GetCurrentThreadId();

        const res = @cmpxchgStrong(usize, &gdwEMIThreadID, 0, @as(usize, tid), .seq_cst, .seq_cst);

        if (res == null) {
            @atomicStore(usize, &gpReturnAddr, 1, .seq_cst);
        }
    }

    return MessageBoxTimeoutW(hWnd, lpText, lpCaption, uType, 0, 0xFFFFFFFF);
}

extern "user32" fn MessageBoxTimeoutW(
    hWnd: ?HWND,
    lpText: ?LPCWSTR,
    lpCaption: ?LPCWSTR,
    uType: MessageBoxType,
    wLanguageId: WORD,
    dwMilliseconds: DWORD,
) callconv(.winapi) i32;
