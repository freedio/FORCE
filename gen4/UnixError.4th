( Decodes a Unix error code into a meaningful message. )
vocabulary UnixError
  requires" FORTH.voc"
  requires" StringFormat.voc"

create ERROR-TEXTS
  001 ,  "EPERM",             "Operation not permitted",
  002 ,  "ENOENT",            "No such file or directory",
  003 ,  "ESRCH",             "No such process",
  004 ,  "EINTR",             "Interrupted system call",
  005 ,  "EIO",               "I/O error",
  006 ,  "ENXIO",             "No such device or address",
  007 ,  "E2BIG",             "Argument list too long",
  008 ,  "ENOEXEC",           "Exec format error",
  009 ,  "EBADF",             "Bad file number",
  010 ,  "ECHILD",            "No child processes",
  011 ,  "AGAIN",             "Try again",
  012 ,  "ENDMEM",            "Out of memory",
  013 ,  "EACCES",            "Permission denied",
  014 ,  "EFAULT",            "Bad address",
  015 ,  "ENOTBLK",           "Block device required",
  016 ,  "EBUSY",             "Device or resource busy",
  017 ,  "EEXIST",            "File exists",
  018 ,  "EXDEV",             "Cross-device link",
  019 ,  "ENODEV",            "No such device",
  020 ,  "ENOTDIR",           "Not a directory",
  021 ,  "EISDIR",            "Is a directory",
  022 ,  "EINVAL",            "Invalid argument",
  023 ,  "ENFILE",            "File table overflow",
  024 ,  "EMFILE",            "Too many open files",
  025 ,  "ENOTTY",            "Not a typewriter",
  026 ,  "ETXTBSY",           "Text file busy",
  027 ,  "EFBIG",             "File too large",
  028 ,  "ENOSPC",            "No space left on device",
  029 ,  "ESPIPE",            "Illegal seek",
  030 ,  "EROFS",             "Read-only file system",
  031 ,  "EMLINK",            "Too many links",
  032 ,  "EPIPE",             "Broken pipe",
  033 ,  "EDOM",              "Math argument out of domain of func",
  034 ,  "ERANGE",            "Math result not representable",

  035 ,  "EDEADLK",           "Resource deadlock would occur",
  036 ,  "ENAMETOOLONG",      "File name too long",
  037 ,  "ENOLCK",            "No record locks available",
  038 ,  "ENOSYS",            "Invalid system call number",

  039 ,  "ENOTEMPTY",         "Directory not empty",
  040 ,  "ELOOP",             "Too many symbolic links encountered",
  041 ,  "EWOULDBLOCK",       "Operation would block",
  042 ,  "ENOMSG",            "No message of desired type",
  043 ,  "EIDRM",             "Identifier removed",
  044 ,  "ECHRNG",            "Channel number out of range",
  045 ,  "EL2NSYNC",          "Level 2 not synchronized",
  046 ,  "EL2HLT",            "Level 3 halted",
  047 ,  "ELRST",             "Level 3 reset",
  048 ,  "ELNRNG",            "Link number out of range",
  049 ,  "EUNATCH",           "Protocol driver not attached",
  050 ,  "ENOCSI",            "No CSI structure available",
  051 ,  "EL2HLT",            "Level 2 halted",
  052 ,  "EBADE",             "Invalid exchange",
  053 ,  "EBADR",             "Invalid request descriptor",
  054 ,  "EXFULL",            "Exchange full",
  055 ,  "ENOANO",            "No anode",
  056 ,  "EBADRQC",           "Invalid request code",
  057 ,  "EBADSLT",           "Invalid slot",

  058 ,  "EDEADLOCK",         "Resource deadlock would occur",

  059 ,  "EBFONT",            "Bad font file format",
  060 ,  "ENOSTR",            "Device not a stream",
  061 ,  "ENODATA",           "No data available",
  062 ,  "ETIME",             "Timer expired",
  063 ,  "ENOSR",             "Out of streams resources",
  064 ,  "ENONET",            "Machine is not on the network",
  065 ,  "ENOPKG",            "Package not installed",
  066 ,  "EREMOTE",           "Object is remote",
  067 ,  "ENOLINK",           "Link has been severed",
  068 ,  "EADV",              "Advertise error",
  069 ,  "SRMNT",             "Stream resource mount error",
  070 ,  "ECOMM",             "Communication error on send",
  071 ,  "EPROTO",            "Protocol error",
  072 ,  "EMULTIHOP",         "Multihop attempted",
  073 ,  "EDOTDOT",           "RFS specific error",
  074 ,  "EBADMSG",           "Not a data message",
  075 ,  "EOVERFLOW",         "Value too large for defined data type",
  076 ,  "ENOTUNIQ",          "Name not unique on network",
  077 ,  "EBADFD",            "File descriptor in bad state",
  078 ,  "EREMCHG",           "Remote address changed",
  079 ,  "ELIBACC",           "Can not access a needed shared library",
  080 ,  "ELIBBAD",           "Accessing a corrupted shared library",
  081 ,  "ELIBSCN",           ".lib section in a.out corrupted",
  082 ,  "ELIBMAX",           "Attempting to link in too many shared libraries",
  083 ,  "ELIBEXEC",          "Cannot exec a shared library directly",
  084 ,  "EILSEQ",            "Illegal byte sequence",
  085 ,  "ERESTART",          "Interrupted system call should be restarted",
  086 ,  "ESTRPIPE",          "Streams pipe error",
  087 ,  "EUSERS",            "Too many users",
  088 ,  "ENOTSOCK",          "Socket operation on non-socket",
  089 ,  "EDESTADDRREQ",      "Destination address required",
  090 ,  "EMSGSIZE",          "Message too long",
  091 ,  "EPROTOTYPE",        "Protocol wrong type for socket",
  092 ,  "ENOPROTOOPT",       "Protocol not available",
  093 ,  "EPROTONOSUPPORT",   "Protocol not supported",
  094 ,  "ESOCKTNOSUPPORT",   "Socket type not supported",
  095 ,  "EOPNOTSUPP",        "Operation not supported on transport endpoint",
  096 ,  "EPFNOSUPPORT",      "Protocol family not supported",
  097 ,  "EAFNOSUPPORT",      "Address family not supported by protocol",
  098 ,  "EADDRINUSE",        "Address already in use",
  099 ,  "EADDRNOTAVAIL",     "Cannot assign requested address",
  100 ,  "ENETDOWN",          "Network is down",
  101 ,  "ENETUNREACH",       "Network is unreachable",
  102 ,  "ENETRESET",         "Network dropped connection because of reset",
  103 ,  "ECONNABORTED",      "Software caused connection abort",
  104 ,  "ECONNRESET",        "Connection reset by peer",
  105 ,  "ENOBUFS",           "No buffer space available",
  106 ,  "EISCONN",           "Transport endpoint is already connected",
  107 ,  "ENOTCONN",          "Transport endpoint is not connected",
  108 ,  "ESHUTDOWN",         "Cannot send after transport endpoint shutdown",
  109 ,  "ETOOMANYREFS",      "Too many references: cannot splice",
  110 ,  "ETIMEDOUT",         "Connection timed out",
  111 ,  "ECONNREFUSED",      "Connection refused",
  112 ,  "EHOSTDOWN",         "Host is down",
  113 ,  "EHOSTUNREACH",      "No route to host",
  114 ,  "EALREADY",          "Operation already in progress",
  115 ,  "EINPROGRESS",       "Operation now in progress",
  116 ,  "ESTALE",            "Stale file handle",
  117 ,  "EUCLEAN",           "Structure needs cleaning",
  118 ,  "ENOTNAM",           "Not a XENIX named type file",
  110 ,  "ENAVAIL",           "No XENIX semaphores available",
  120 ,  "EISNAM",            "Is a named type file",
  121 ,  "EREMOTEIO",         "Remote I/O error",
  122 ,  "EDQUOT",            "Quota exceeded",

  123 ,  "ENOMEDIUM",         "No medium found",
  124 ,  "EMEDIUMTYPE",       "Wrong medium type",
  125 ,  "ECANCELED",         "Operation Canceled",
  126 ,  "ENOKEY",            "Required key not available",
  127 ,  "EKEYEXPIRED",       "Key has expired",
  128 ,  "EKEYREVOKED",       "Key has been revoked",
  129 ,  "EKEYREJECTED",      "Key was rejected by service",

  130 ,  "EOWNERDEAD",        "Owner died",
  131 ,  "ENOTRECOVERABLE",   "State not recoverable",

  132 ,  "ERFKILL",           "Operation not possible due to RF-kill",

  133 ,  "EHWPOISON",         "Memory page has hardware error",


=== API ===

: >errtext ( errno -- msg$ )  dup 1 134 between if  1- 3* ERROR-TEXTS swap cells+  2cells+ @  else
  1 "Unknown error code %d" |$|  then ;

vocabulary;
