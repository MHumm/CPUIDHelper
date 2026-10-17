{*****************************************************************************
  The CPUIDHelper team (see file NOTICE.txt) licenses this file
  to you under the Apache License, Version 2.0 (the
  "License"); you may not use this file except in compliance
  with the License. A copy of this licence is found in the root directory
  of this project in the file LICENCE.txt or alternatively at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing,
  software distributed under the License is distributed on an
  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  KIND, either express or implied.  See the License for the
  specific language governing permissions and limitations
  under the License.
*****************************************************************************}

/// <summary>
///   x86 and x64 CPU instruction support functions.
///   This class only works for Intel/AMD cpus - ARM will result.
///   The functions defined here return true if the feature is availabe
///   for the cpu
/// </summary>
unit CPUSupport;

interface

type
  /// <summary>
  ///   Determines various x86/AMD CPU capabilities
  /// </summary>
  TCPUSupport = class(TObject)
  public
    // flags are set in initialization
    class var AES        : Boolean;
    class var AVX        : Boolean;
    class var AVX2       : Boolean;

    class var AVX512VL   : Boolean;
    class var AVX512BW   : Boolean;
    class var AVX512CD   : Boolean;
    class var AVX512ER   : Boolean;
    class var AVX512PF   : Boolean;

    class var AVX512IFMA : Boolean;
    class var AVX512DQ   : Boolean;
    class var AVX512F    : Boolean;

    /// <summary>
    ///   Is acceleration for SHA1 and SHA256 supported?
    /// </summary>
    class var SHA      : Boolean;
    class var SHA512   : Boolean;

    /// <summary>
    ///   Chinese 128 bit block chiffre used in chinese WiFi standard
    /// </summary>
    class var SM4            : Boolean;
    class var SM3            : Boolean;

    /// <summary>
    ///   Are cryptographically protected memory ranges supported?
    /// </summary>
    class var PRMRR    : Boolean;

    class var SSE      : Boolean;
    class var SSE2     : Boolean;
    class var SSE3     : Boolean;
    class var SSE41    : Boolean;
    class var SSE42    : Boolean;

    class var RDRand   : Boolean;
    class var RDSeed   : Boolean;

    /// <summary>
    ///   Supports realizing a power saving monitor/wait functionality
    /// </summary>
    class var MWait    : Boolean;

    /// <summary>
    ///   Enhanced REP MOVSB/STOSB
    /// </summary>
    class var ERMS     : Boolean;
    /// <summary>
    ///   Bit manipulations 2
    /// </summary>
    class var BMI1     : Boolean;
    /// <summary>
    ///   Bit manipulations 2
    /// </summary>
    class var BMI2     : Boolean;

    class var MOVDIR64B: Boolean;
    class var MOVDIRI  : Boolean;

    /// <summary>
    ///   Fast zeroing of memory
    /// </summary>
    class var FastZeroMem : Boolean;

    /// <summary>
    ///   Read CPU ID
    /// </summary>
    class var RDPID    : Boolean;
    /// <summary>
    ///   Total Memory Encryption
    /// </summary>
    class var TME      : Boolean;

    class var AVX512BITALG   : Boolean;
    class var AVX512VNNI     : Boolean;
    class var AVX512VBMI2    : Boolean;
    class var AVX512VBMI     : Boolean;
    class var AVX512FP16     : Boolean;
    class var AVX512VP2I     : Boolean;
    class var AVX512BF16     : Boolean;
    class var AVXX512QFMA    : Boolean;
    class var AVXX512QVNNIW  : Boolean;

    class var AVX_IFMA       : Boolean;
    class var AVX_VNNI       : Boolean;
    class var AVX_NE_CONVERT : Boolean;
    class var AVX_VNNI_INT8  : Boolean;
    class var AVX_VNNI_INT16 : Boolean;
    class var AVX10          : Boolean;

    /// <summary>
    ///   Advanced matrix operations on 8 bit integers
    /// </summary>
    class var AMX_INT8    : Boolean;
    /// <summary>
    ///   Advanced matrix operations
    /// </summary>
    class var AMX_TILE    : Boolean;
    /// <summary>
    ///   Advanced matrix operations on 16 bit floats (BFloat)
    /// </summary>
    class var AMX_BF16    : Boolean;
    /// <summary>
    ///   Advanced matrix operations on 16 bit floats (FPoint16)
    /// </summary>
    class var AMX_FP16    : Boolean;


    /// <summary>
    ///   User mode energy efficient wait
    /// </summary>
    class var WAITPKG      : Boolean;

    /// <summary>
    ///   Finish all other instructions etc. before processing the next one
    /// </summary>
    class var SERIALIZE      : Boolean;


    class var FSREPMOVSB     : Boolean;
    class var MOVRS          : Boolean;

    class var FAST_REP_CMPSB : Boolean;
    class var FAST_REP_STOSB : Boolean;
    class var FAST_REP_MOVSB : Boolean;

    class var DEDUP          : Boolean;
    class var ARCH_PERFMON   : Boolean;
    class var CMPCCXADD      : Boolean;

    class var RAO_INT        : Boolean;

    class var UTMR           : Boolean;
    class var AMX_COMPLEX    : Boolean;  end;

implementation

{$IFDEF CPUX64}
  {$DEFINE x64}
{$ENDIF}
{$IFDEF cpux86_64}
  {$DEFINE x64}
{$ENDIF}

{$IFDEF CPU86}
  {$DEFINE x86}
{$ENDIF}
{$IFDEF CPUX86}
  {$DEFINE x86}
{$ENDIF}

{$IFDEF CPU386}
  {$DEFINE x86}
{$ENDIF}

{$IF Defined(x64) or Defined(x86)}
{$WARN SYMBOL_PLATFORM OFF}

/// <summary>
///   Inits all CPU feature flags with the real capabilities of the CPU
/// </summary>
procedure InitFlags;
var
  reg  : TCPUIDRec;
  nids : LongWord;
begin
  // read maximum supported FunctionID
  reg  := GetCPUID(0, 0);
  nids := reg.EAX;

  if nids >= 1 then
  begin
    // query flags to find out supported instruction sets
    reg := GetCPUID(1, 0);
    TCPUSupport.SSE   := (reg.EDX and (1 shl 25)) <> 0;
    TCPUSupport.SSE2  := (reg.EDX and (1 shl 26)) <> 0;
    TCPUSupport.SSE3  := (reg.ECX and (1 shl  9)) <> 0;
    TCPUSupport.SSE41 := (reg.ECX and (1 shl 19)) <> 0;
    TCPUSupport.SSE42 := (reg.ECX and (1 shl 20)) <> 0;
    TCPUSupport.AES   := (reg.ECX and (1 shl 25)) <> 0;

    TCPUSupport.AVX    := (reg.ECX and (1 shl 28)) <> 0;
    TCPUSupport.RDRAND := (reg.ECX and (1 shl 30)) <> 0;

    TCPUSupport.MWait  := (reg.ECX and (1 shl  3)) <> 0;
  end;

  if nids >= 7 then
  begin
    // query further flags to find out supported instruction sets
    reg := GetCPUID($7, 0);
    TCPUSupport.AVX2         := (reg.EBX and (1 shl  5)) <> 0;
    TCPUSupport.RDSEED       := (reg.EBX and (1 shl 18)) <> 0;

    TCPUSupport.AVX512VL     := (reg.EBX and (1 shl 31)) <> 0;
    TCPUSupport.AVX512BW     := (reg.EBX and (1 shl 30)) <> 0;
    TCPUSupport.AVX512CD     := (reg.EBX and (1 shl 28)) <> 0;
    TCPUSupport.AVX512ER     := (reg.EBX and (1 shl 27)) <> 0;
    TCPUSupport.AVX512PF     := (reg.EBX and (1 shl 26)) <> 0;

    TCPUSupport.SHA          := (reg.EBX and (1 shl 29)) <> 0;

    TCPUSupport.PRMRR        := (reg.EBX and (1 shl  2)) <> 0;

    TCPUSupport.AVX512IFMA   := (reg.EBX and (1 shl 21)) <> 0;
    TCPUSupport.AVX512DQ     := (reg.EBX and (1 shl 17)) <> 0;
    TCPUSupport.AVX512F      := (reg.EBX and (1 shl 16)) <> 0;

    TCPUSupport.ERMS         := (reg.EBX and (1 shl  9)) <> 0;
    TCPUSupport.BMI1         := (reg.EBX and (1 shl  3)) <> 0;
    TCPUSupport.BMI2         := (reg.EBX and (1 shl  8)) <> 0;

    TCPUSupport.MOVDIR64B    := (reg.ECX and (1 shl 28)) <> 0;
    TCPUSupport.MOVDIRI      := (reg.ECX and (1 shl 27)) <> 0;

    TCPUSupport.FastZeroMem  := (reg.ECX and (1 shl 15)) <> 0;
    TCPUSupport.RDPID        := (reg.ECX and (1 shl 22)) <> 0;
    TCPUSupport.TME          := (reg.ECX and (1 shl 13)) <> 0;

    TCPUSupport.AVX512BITALG := (reg.ECX and (1 shl 12)) <> 0;
    TCPUSupport.AVX512VNNI   := (reg.ECX and (1 shl 11)) <> 0;
    TCPUSupport.AVX512VBMI2  := (reg.ECX and (1 shl  6)) <> 0;
    TCPUSupport.AVX512VBMI   := (reg.ECX and (1 shl  1)) <> 0;

    TCPUSupport.WAITPKG      := (reg.ECX and (1 shl  5)) <> 0;

    TCPUSupport.AMX_INT8     := (reg.EDX and (1 shl 25)) <> 0;
    TCPUSupport.AMX_TILE     := (reg.EDX and (1 shl 24)) <> 0;
    TCPUSupport.AMX_BF16     := (reg.EDX and (1 shl 22)) <> 0;

    TCPUSupport.AVX512FP16   := (reg.EDX and (1 shl 23)) <> 0;
    TCPUSupport.SERIALIZE    := (reg.EDX and (1 shl 14)) <> 0;

    TCPUSupport.AVX512VP2I   := (reg.EDX and (1 shl  8)) <> 0;
    TCPUSupport.AVXX512QFMA  := (reg.EDX and (1 shl  3)) <> 0;
    TCPUSupport.AVXX512QVNNIW:= (reg.EDX and (1 shl  2)) <> 0;

    TCPUSupport.FSREPMOVSB   := (reg.EDX and (1 shl  4)) <> 0;

    // further sub leaves supported?
    if (reg.EAX > 0) then
    begin
      reg := GetCPUID($7, 1);

      TCPUSupport.MOVRS     := (reg.EAX and (1 shl 31)) <> 0;
      TCPUSupport.AVX_IFMA  := (reg.EAX and (1 shl 23)) <> 0;

      TCPUSupport.AMX_FP16  := (reg.EAX and (1 shl 21)) <> 0;

      TCPUSupport.FAST_REP_CMPSB := (reg.EAX and (1 shl 12)) <> 0;
      TCPUSupport.FAST_REP_STOSB := (reg.EAX and (1 shl 11)) <> 0;
      TCPUSupport.FAST_REP_MOVSB := (reg.EAX and (1 shl 10)) <> 0;

      TCPUSupport.DEDUP          := (reg.EAX and (1 shl  9)) <> 0;
      TCPUSupport.ARCH_PERFMON   := (reg.EAX and (1 shl  8)) <> 0;
      TCPUSupport.CMPCCXADD      := (reg.EAX and (1 shl  7)) <> 0;
      TCPUSupport.AVX512BF16     := (reg.EAX and (1 shl  5)) <> 0;
      TCPUSupport.AVX_VNNI       := (reg.EAX and (1 shl  4)) <> 0;
      TCPUSupport.RAO_INT        := (reg.EAX and (1 shl  3)) <> 0;
      TCPUSupport.SM4            := (reg.EAX and (1 shl  2)) <> 0;
      TCPUSupport.SM3            := (reg.EAX and (1 shl  1)) <> 0;
      TCPUSupport.SHA512         := (reg.EAX and (1 shl  0)) <> 0;

      TCPUSupport.AVX10          := (reg.EDX and (1 shl 19)) <> 0;
      TCPUSupport.UTMR           := (reg.EDX and (1 shl 13)) <> 0;
      TCPUSupport.AVX_VNNI_INT16 := (reg.EDX and (1 shl 10)) <> 0;
      TCPUSupport.AMX_COMPLEX    := (reg.EDX and (1 shl  8)) <> 0;
      TCPUSupport.AVX_NE_CONVERT := (reg.EDX and (1 shl  5)) <> 0;
      TCPUSupport.AVX_VNNI_INT8  := (reg.EDX and (1 shl  4)) <> 0;
    end;
  end;
end;
{$ENDIF}

initialization
  TCPUSupport.AES            := False;
  TCPUSupport.AVX            := False;
  TCPUSupport.AVX2           := False;

  TCPUSupport.SSE            := False;
  TCPUSupport.SSE2           := False;
  TCPUSupport.SSE3           := False;
  TCPUSupport.SSE41          := False;
  TCPUSupport.SSE42          := False;

  TCPUSupport.RDRand         := False;
  TCPUSupport.RDSeed         := False;

  TCPUSupport.AVX512VL       := False;
  TCPUSupport.AVX512BW       := False;
  TCPUSupport.AVX512CD       := False;
  TCPUSupport.AVX512ER       := False;
  TCPUSupport.AVX512PF       := False;
  TCPUSupport.AVX512IFMA     := False;
  TCPUSupport.AVX512DQ       := False;
  TCPUSupport.AVX512F        := False;

  TCPUSupport.SHA            := False;
  TCPUSupport.PRMRR          := False;
  TCPUSupport.TME            := False;

  TCPUSupport.ERMS           := False;
  TCPUSupport.BMI1           := False;
  TCPUSupport.BMI2           := False;

  TCPUSupport.MOVDIR64B      := False;
  TCPUSupport.MOVDIRI        := False;

  TCPUSupport.FastZeroMem    := False;

  TCPUSupport.RDPID          := False;

  TCPUSupport.AVX512BITALG   := False;
  TCPUSupport.AVX512VNNI     := False;
  TCPUSupport.AVX512VBMI2    := False;
  TCPUSupport.AVX512VBMI     := False;

  TCPUSupport.WAITPKG        := False;

  TCPUSupport.AMX_INT8       := False;
  TCPUSupport.AMX_TILE       := False;
  TCPUSupport.AMX_BF16       := False;

  TCPUSupport.AVX512FP16     := False;

  TCPUSupport.SERIALIZE      := False;

  TCPUSupport.AVX512VP2I     := False;
  TCPUSupport.AVXX512QFMA    := False;
  TCPUSupport.AVXX512QVNNIW  := False;

  TCPUSupport.FSREPMOVSB     := False;

  TCPUSupport.MOVRS          := False;

  TCPUSupport.AVX_IFMA       := False;
  TCPUSupport.AMX_FP16       := False;

  TCPUSupport.FAST_REP_CMPSB := False;
  TCPUSupport.FAST_REP_STOSB := False;
  TCPUSupport.FAST_REP_MOVSB := False;

  TCPUSupport.DEDUP          := False;
  TCPUSupport.ARCH_PERFMON   := False;
  TCPUSupport.CMPCCXADD      := False;
  TCPUSupport.AVX512BF16     := False;
  TCPUSupport.AVX_VNNI       := False;
  TCPUSupport.RAO_INT        := False;
  TCPUSupport.SM4            := False;
  TCPUSupport.SM3            := False;
  TCPUSupport.SHA512         := False;

  TCPUSupport.AVX10          := False;
  TCPUSupport.UTMR           := False;
  TCPUSupport.AVX_VNNI_INT16 := False;
  TCPUSupport.AMX_COMPLEX    := False;
  TCPUSupport.AVX_NE_CONVERT := False;
  TCPUSupport.AVX_VNNI_INT8  := False;

  {$IF Defined(x64) or Defined(x86)}

    InitFlags;
  {$IFEND}
end.
