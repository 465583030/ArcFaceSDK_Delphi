(*******************************************************
 * ��������ʶ��SDK��װ TBitmap ��
 * ��Ȩ���� (C) 2017 NJTZ  eMail:yhdgs@qq.com
 *******************************************************)

unit ArcFaceSDK;

interface

uses Windows, Messages, SysUtils, System.Classes, math,
  amcomdef, ammemDef,
  arcsoft_fsdk_face_detection,
  arcsoft_fsdk_face_recognition,
  arcsoft_fsdk_face_tracking, asvloffscreendef, merrorDef,
  arcsoft_fsdk_age_estimation, arcsoft_fsdk_gender_estimation,
  Vcl.Graphics, Vcl.Imaging.jpeg, System.Generics.Collections;

type

  TOnLogEvent = procedure(Const Msg: String) of object;

  TImgDataInfo = record
    pImgData: PByte;
    Width: Integer;
    Height: Integer;
    LineBytes: Integer;
    BitCount: Integer;
  end;

  TFaceBaseInfo = record
    FaceRect: MRECT;
    FaceOrient: Integer;
    Age: Integer;
    Gender: Integer;
  private
  public
    procedure Init;
  end;

  TFaceFullInfo = record
    FaceRect: MRECT;
    FaceOrient: Integer;
    Age: Integer;
    Gender: Integer;
    Model: AFR_FSDK_FACEMODEL;
  private
  public
    procedure Init;
  end;

  TFaceModels = class(TObject)
  private
    FModels: TList<AFR_FSDK_FACEMODEL>;
    function GetCount: Integer;
    function GetFaceModel(Index: Integer): AFR_FSDK_FACEMODEL;
    function GetItems(Index: Integer): AFR_FSDK_FACEMODEL;
  public
    constructor Create;
    destructor Destroy; override;
    function AddModel(AModel: AFR_FSDK_FACEMODEL): Integer;
    procedure Assign(ASource: TFaceModels); virtual;
    procedure AddModels(ASource: TFaceModels);
    procedure Clear; virtual;
    procedure Delete(Index: Integer);
    property Count: Integer read GetCount;
    property FaceModel[Index: Integer]: AFR_FSDK_FACEMODEL read GetFaceModel;
    property Items[Index: Integer]: AFR_FSDK_FACEMODEL read GetItems;
  end;

  TArcFaceSDK = class(TObject)
  private
    FAppID: string;
    FEstimationBufferSize: Int64;
    FFaceAgeKey: String;
    FFaceRecognitionKey: string;
    FFaceTrackingKey: string;
    FFaceDetectionKey: string;
    FFaceGenderKey: String;
    FMaxFace: Integer;
    FScale: Integer;
    FWorkKBufferSize: Int64;
    FOnLog: TOnLogEvent;
    FOrientPriority: TAFD_FSDK_OrientPriority;
    FpFaceRecognitionBuf: PByte;
    FpFaceTrackingBuf: PByte;
    FpFaceDetectionBuf: PByte;
    FpFaceAgeBuf: PByte;
    FpFaceGenderBuf: PByte;
    procedure SetMaxFace(const Value: Integer);
    procedure SetScale(const Value: Integer);
  protected
    FFaceRecognitionEngine: MHandle;
    FFaceTrackingEngine: MHandle;
    FFaceDetectionEngine: MHandle;
    FFaceAgeEngine: MHandle;
    FFaceGenderEngine: MHandle;
    procedure DoLog(const Msg: String);
  public
    constructor Create;
    destructor Destroy; override;
    function DetectAndRecognitionFacesFromBmp(ABitmap: TBitmap; var AFaceRegions:
      TList<AFR_FSDK_FACEINPUT>; var AFaceModels: TFaceModels): Boolean;
    function DetectFacesAndAgeGenderFromBitmap(ABitmap: TBitmap; var AFaceInfos:
      TList<TFaceBaseInfo>): Boolean;
    function DetectFacesFromBmp(ABitmap: TBitmap; var AFaceRegions:
      TList<AFR_FSDK_FACEINPUT>): Boolean;
    function TrackFacesFromBmp(ABitmap: TBitmap; var AFaceRegions:
      TList<AFR_FSDK_FACEINPUT>): Boolean;
    function DetectFacesFromBmpFile(AFile: string; var AFaceRegions:
      TList<AFR_FSDK_FACEINPUT>): Boolean;
    function DRAGfromJPGFile(AFileName: string; var AFaceInfos:
      TList<TFaceBaseInfo>; var AFaceModels: TFaceModels): Boolean; overload;
    function DRAGfromBmp(ABitmap: TBitmap; var AFaceInfos: TList<TFaceBaseInfo>;
      var AFaceModels: TFaceModels): Boolean; overload;
    function DRAGfromBmpFile(AFileName: string; var AFaceInfos:
      TList<TFaceBaseInfo>; var AFaceModels: TFaceModels): Boolean; overload;
    class procedure DrawFaceRectAgeGender(ACanvas: TCanvas; AFaceIdx: Integer;
      AFaceInfo: TFaceBaseInfo; AColor: TColor = clBlue; AWidth: Integer = 2;
      ADrawIndex: Boolean = true; ATextSize: Integer = 0);
    class procedure DrawFaceRect(ACanvas: TCanvas; AFaceIdx: Integer; AFaceInfo:
      AFR_FSDK_FACEINPUT; AColor: TColor = clBlue; AWidth: Integer = 2;
      ADrawIndex: Boolean = true; ATextSize: Integer = 0);
    function TrackFacesFromBmpFile(AFile: string; var AFaceRegions:
      TList<AFR_FSDK_FACEINPUT>): Boolean;
    class procedure ExtractFaceBoxs(AFaces: AFD_FSDK_FACERES; AFaceRegions:
      TList<AFR_FSDK_FACEINPUT>); overload;
    class procedure ExtractFaceBoxs(AFaces: AFT_FSDK_FACERES; var AFaceRegions:
      TList<AFR_FSDK_FACEINPUT>); overload;
    class procedure ExtractFaceAges(AFaceAgeResults: ASAE_FSDK_AGERESULT; var
      AFaceAges: TArray<Integer>); overload;
    class procedure ExtractFaceGenders(AFaceGenderResults
      : ASGE_FSDK_GENDERRESULT;
      var AFaceGenders: TArray<Integer>); overload;
    function ExtractFaceFeature(AFaceInput: ASVLOFFSCREEN; AFaceRegion:
      AFR_FSDK_FACEINPUT; var AFaceModel: AFR_FSDK_FACEMODEL): Boolean;
    function ExtractFaceFeatures(AFaceInput: ASVLOFFSCREEN; AFaceRegions:
      TList<AFR_FSDK_FACEINPUT>; var AFaceModels: TFaceModels): Boolean;
    function ExtractFaceFeatureFromBmp(ABitmap: TBitmap; AFaceRegion:
      AFR_FSDK_FACEINPUT; var AFaceModel: AFR_FSDK_FACEMODEL): Boolean;
    function ExtractFaceFeaturesFromBmp(ABitmap: TBitmap; AFaceRegions:
      TList<AFR_FSDK_FACEINPUT>; var AFaceModels: TFaceModels): Boolean;
    function ExtractFaceFeatureFromBmpFile(AFile: string; AFaceRegion:
      AFR_FSDK_FACEINPUT; var AFaceModel: AFR_FSDK_FACEMODEL): Boolean;
    function ExtractFaceFeaturesFromBmpFile(AFile: string; AFaceRegions:
      TList<AFR_FSDK_FACEINPUT>; var AFaceModels: TFaceModels): Boolean;
    function InitialFaceDetectionEngine(Deinitial: Boolean): Integer;
    function InitialFaceTrackingEngine(Deinitial: Boolean): Integer;
    function InitialFaceRecognitionEngine(Deinitial: Boolean): Integer;
    function InitialFaceAgeEngine(Deinitial: Boolean): Integer;
    function InitialFaceGenderEngine(Deinitial: Boolean): Integer;
    function MatchFace(AFaceModel1, AFaceModel2: AFR_FSDK_FACEMODEL): Single;
    function MatchFaceWithBitmaps(ABitmap1, ABitmap2: TBitmap): Single;
    function UnInitialFaceDetectionEngine: Integer;
    function UnInitialFaceTrackingEngine: Integer;
    function UnInitialFaceRecognitionEngine: Integer;
    class function ReadBmp(ABitmap: TBitmap; var AImgData: PByte; var AWidth,
      AHeight, ALineBytes: Integer): Boolean;
    class function ReadBmpFile(AFileName: string; var AImgData: PByte;
      var AWidth,
      AHeight, ALineBytes: Integer): Boolean; overload;
    class function ReadBmpFile(AFileName: string; ABitmap: TBitmap): Boolean;
      overload;
    class function ReadJpegFile(AFileName: string; var AImgData: PByte;
      var AWidth,
      AHeight, ABitCount: Integer): Boolean; overload;
    class function ReadBmpStream(AStream: TMemoryStream; var AImgData: PByte; var
      AWidth, AHeight, ALineBytes: Integer): Boolean;
    class function ReadJpegFile(AFileName: string; ABitmap: TBitmap): Boolean;
      overload;
    function TrackFacesAndAgeGenderFromBmp(ABitmap: TBitmap; var AFaceInfos:
      TList<TFaceBaseInfo>): Boolean;
    function UnInitialFaceAgeEngine: Integer;
    function UnInitialFaceGenderEngine: Integer;
    property AppID: String read FAppID write FAppID;
    property FaceDetectionKey: string read FFaceDetectionKey write
      FFaceDetectionKey;
    property FaceRecognitionKey: string read FFaceRecognitionKey write
      FFaceRecognitionKey;
    property FaceTrackingKey: string read FFaceTrackingKey
      write FFaceTrackingKey;
    property MaxFace: Integer read FMaxFace write SetMaxFace;
    property OnLog: TOnLogEvent read FOnLog write FOnLog;
    property EstimationBufferSize: Int64 read FEstimationBufferSize write
      FEstimationBufferSize;
    property FaceAgeKey: String read FFaceAgeKey write FFaceAgeKey;
    property FaceGenderKey: String read FFaceGenderKey write FFaceGenderKey;
    property OrientPriority: TAFD_FSDK_OrientPriority read FOrientPriority write
      FOrientPriority;
    property Scale: Integer read FScale write SetScale;
    property WorkKBufferSize: Int64 read FWorkKBufferSize
      write FWorkKBufferSize;
  end;

  TuJpegImage = class(TJPEGImage)
  public
    function BitmapData: TBitmap;
  end;

  TEdzFaceModels = class(TFaceModels)
  private
    FRyID: String;
    FParams: String;
  public
    constructor Create;
    procedure Assign(ASource: TFaceModels); override;
    procedure Clear; override;
    property RyID: String read FRyID write FRyID;
    property Params: String read FParams write FParams;
  end;

implementation


constructor TArcFaceSDK.Create;
begin
  inherited;

  FAppID := Your Key;
  //�������(FD) Key
  FFaceDetectionKey := 'Your Key';
  //����ʶ��(FR) Key
  FFaceRecognitionKey := 'Your Key';
  //����׷��(FT) Key
  FFaceTrackingKey := 'Your Key';
  //����ʶ��(Age)Key
  FFaceAgeKey := 'Your Key';
  //�Ա�ʶ��(Gender)Key
  FFaceGenderKey := 'Your Key';

  FWorkKBufferSize := 40 * 1024 * 1024;
  FEstimationBufferSize := 30 * 1024 * 1024;
  FScale := 16;
  FMaxFace := 10;
  FOrientPriority := TAFD_FSDK_OrientPriority.AFD_FSDK_OPF_0_HIGHER_EXT;

  FFaceDetectionEngine := nil;
  FFaceRecognitionEngine := nil;
  FFaceTrackingEngine := nil;
  FFaceAgeEngine := nil;
  FFaceGenderEngine := nil;

  FpFaceDetectionBuf := nil;
  FpFaceRecognitionBuf := nil;
  FpFaceTrackingBuf := nil;
  FpFaceAgeBuf := nil;
  FpFaceGenderBuf := nil;

end;

destructor TArcFaceSDK.Destroy;
begin
  UnInitialFaceDetectionEngine;
  UnInitialFaceTrackingEngine;
  UnInitialFaceRecognitionEngine;
  UnInitialFaceAgeEngine;
  UnInitialFaceGenderEngine;
  inherited;
end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.DetectAndRecognitionFacesFromBmp
 ����:      �������λ�ò���ȡ������֧�ֶ�������
 ����:      Bird
 ����:      2017.11.19
 ����:      ABitmap: TBitmap; //Դλͼ
 var AFaceRegions: TList<AFR_FSDK_FACEINPUT>; //�������λ����Ϣ�б�
 var AFaceModels: TFaceModels //�������������Ϣ
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
function TArcFaceSDK.DetectAndRecognitionFacesFromBmp(ABitmap: TBitmap; var
  AFaceRegions: TList<AFR_FSDK_FACEINPUT>; var AFaceModels: TFaceModels):
  Boolean;
var
  pImgData: PByte;
  iWidth, iHeight, iLineBytes: Integer;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
  nRet: MRESULT;
{$IFDEF DEBUG}
  T: Cardinal;
{$ENDIF}
begin
  Result := False;

  if FFaceDetectionEngine = nil then
    Exit;

  if AFaceRegions = nil then
    AFaceRegions := TList<AFR_FSDK_FACEINPUT>.Create;

  pImgData := nil;
{$IFDEF DEBUG}
  T := GetTickCount;
{$ENDIF}
  if not ReadBmp(ABitmap, pImgData, iWidth, iHeight, iLineBytes) then
    Exit;
{$IFDEF DEBUG}
  T := GetTickCount - T;
  DoLog('�������ݺ�ʱ��' + IntToStr(T));
{$ENDIF}
  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := iWidth;
  offInput.i32Height := iHeight;

  offInput.ppu8Plane[0] := IntPtr(pImgData);
  offInput.pi32Pitch[0] := iLineBytes;
  //�������
{$IFDEF DEBUG}
  T := GetTickCount;
{$ENDIF}
  nRet := AFD_FSDK_StillImageFaceDetection(FFaceDetectionEngine, @offInput,
    pFaceRes);
{$IFDEF DEBUG}
  T := GetTickCount - T;
  DoLog('���������ʱ��' + IntToStr(T));
{$ENDIF}
  if nRet = MOK then
  begin
    ExtractFaceBoxs(pFaceRes^, AFaceRegions);

    if AFaceModels = nil then
      AFaceModels := TFaceModels.Create;
{$IFDEF DEBUG}
    T := GetTickCount;
{$ENDIF}
    Result := ExtractFaceFeatures(offInput, AFaceRegions, AFaceModels);
{$IFDEF DEBUG}
    T := GetTickCount - T;
    DoLog('��ȡ������ʱ��' + IntToStr(T));
{$ENDIF}
  end;

  if pImgData <> nil then
    FreeMem(pImgData);

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.TrackFacesAndAgeGenderFromIEBitmap1
 ����:      ��Bitmap�л�ȡ����λ�á��Ա��������Ϣ�б�
 ����:      DelphiDX10
 ����:      2018.01.31
 ����:      ABitmap: TBitmap; var AFaceInfos: TList<TFaceBaseInfo>
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
function TArcFaceSDK.DetectFacesAndAgeGenderFromBitmap(ABitmap: TBitmap; var
  AFaceInfos: TList<TFaceBaseInfo>): Boolean;
var
  pImgData: PByte;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
  lFaceRes_Age: ASAE_FSDK_AGEFACEINPUT;
  lFaceRes_Gender: ASGE_FSDK_GENDERFACEINPUT;
  lFaceRegions: TList<AFR_FSDK_FACEINPUT>;
  lAgeRes: ASAE_FSDK_AGERESULT;
  lGenderRes: ASGE_FSDK_GENDERRESULT;
  lAges: TArray<Integer>;
  lGenders: TArray<Integer>;
  lFaceInfo: TFaceBaseInfo;
  i, iFaces: Integer;
  iWidth, iHeight, iLineBytes: Integer;
  ArrFaceOrient: array of AFD_FSDK_OrientCode;
  ArrFaceRect: array of MRECT;
begin
  Result := False;

  if AFaceInfos = nil then
    AFaceInfos := TList<TFaceBaseInfo>.Create;

  if FFaceDetectionEngine = nil then
    Exit;

  pImgData := nil;

  if not ReadBmp(ABitmap, pImgData, iWidth, iHeight, iLineBytes)
  then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := iWidth;
  offInput.i32Height := iHeight;

  offInput.ppu8Plane[0] := IntPtr(pImgData);
  offInput.pi32Pitch[0] := iLineBytes;

  lFaceRegions := TList<AFR_FSDK_FACEINPUT>.Create;
  try
    //�������
    if AFD_FSDK_StillImageFaceDetection(FFaceDetectionEngine, @offInput,
      pFaceRes) = MOK then
    begin
      //�ֽ�����λ����Ϣ
      ExtractFaceBoxs(pFaceRes^, lFaceRegions);
      if lFaceRegions.Count > 0 then
      begin
        iFaces := lFaceRegions.Count;
        SetLength(ArrFaceOrient, iFaces);
        SetLength(ArrFaceRect, iFaces);
        for i := 0 to iFaces - 1 do
        begin
          ArrFaceOrient[i] := lFaceRegions.Items[i].lOrient;
          ArrFaceRect[i] := lFaceRegions.Items[i].rcFace;
        end;

        //�������
        if (FFaceAgeEngine <> nil) then
        begin
          with lFaceRes_Age do
          begin
            pFaceRectArray := @ArrFaceRect[0];
            pFaceOrientArray := @ArrFaceOrient[0];
            lFaceNumber := iFaces;
          end;

          if ASAE_FSDK_AgeEstimation_StaticImage(
            FFaceAgeEngine, //[in] age estimation engine
            @offInput, //[in] the original image information
            //[in] the face rectangles information
            @lFaceRes_Age,
            //[out] the results of age estimation
            lAgeRes
            ) = MOK then
            //�ֽ���������
            ExtractFaceAges(lAgeRes, lAges);

        end;

        //����Ա�
        if (FFaceGenderEngine <> nil) then
        begin
          with lFaceRes_Gender do
          begin
            pFaceRectArray := @ArrFaceRect[0];
            pFaceOrientArray := @ArrFaceOrient[0];
            lFaceNumber := iFaces;
          end;

          if ASGE_FSDK_GenderEstimation_StaticImage(
            FFaceGenderEngine, //[in] Gender estimation engine
            @offInput, //[in] the original imGender information
            //[in] the face rectangles information
            @lFaceRes_Gender,
            //[out] the results of Gender estimation
            lGenderRes
            ) = MOK then
            //�ֽ������Ա�
            ExtractFaceGenders(lGenderRes, lGenders);

        end;

        for i := 0 to iFaces - 1 do
        begin
          lFaceInfo.Init;
          lFaceInfo.FaceRect := ArrFaceRect[i];
          lFaceInfo.FaceOrient := ArrFaceOrient[i];
          if i < Length(lAges) then
            lFaceInfo.Age := lAges[i];
          if i < Length(lGenders) then
            lFaceInfo.Gender := lGenders[i];
          AFaceInfos.Add(lFaceInfo);
        end;
      end;

    end;
  finally
    FreeAndNil(lFaceRegions);
  end;

  if pImgData <> nil then
    FreeMem(pImgData)

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.DetectFacesFromBmp
 ����:      ��λͼ�л�ȡ����λ����Ϣ�б�
 ����:      Bird
 ����:      2017.11.19
 ����:      ABitmap: TBitmap;//Դλͼ
 var AFaceRegions: TList<AFR_FSDK_FACEINPUT> //�������λ���б�
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
function TArcFaceSDK.DetectFacesFromBmp(ABitmap: TBitmap; var AFaceRegions:
  TList<AFR_FSDK_FACEINPUT>): Boolean;
var
  pImgData: PByte;
  iWidth, iHeight, iLineBytes: Integer;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
begin
  Result := False;

  if FFaceDetectionEngine = nil then
    Exit;

  pImgData := nil;

  //��ȡλͼ���ڴ���
  if not ReadBmp(ABitmap, pImgData, iWidth, iHeight, iLineBytes) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := iWidth;
  offInput.i32Height := iHeight;

  offInput.ppu8Plane[0] := IntPtr(pImgData);
  offInput.pi32Pitch[0] := iLineBytes;
  //����API�������
  if AFD_FSDK_StillImageFaceDetection(FFaceDetectionEngine, @offInput, pFaceRes)
    = MOK then
  begin
    //��ȡ����λ�ÿ���Ϣ���б�
    ExtractFaceBoxs(pFaceRes^, AFaceRegions);
  end;

  if pImgData <> nil then
    FreeMem(pImgData);

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.TrackFacesFromBmp
 ����:      ��ȡ����λ����Ϣ�б�
 ����:      Bird
 ����:      2017.09.24
 ����:      ABitmap: TBitmap; //Դλͼ
 var AFaceRegions: TList<AFR_FSDK_FACEINPUT> //�������λ����Ϣ�б�
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
function TArcFaceSDK.TrackFacesFromBmp(ABitmap: TBitmap; var AFaceRegions:
  TList<AFR_FSDK_FACEINPUT>): Boolean;
var
  pImgData: PByte;
  iWidth, iHeight, iLineBytes: Integer;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFT_FSDK_FACERES;
begin
  Result := False;

  if FFaceTrackingEngine = nil then
    Exit;

  pImgData := nil;

  if not ReadBmp(ABitmap, pImgData, iWidth, iHeight, iLineBytes) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := iWidth;
  offInput.i32Height := iHeight;

  offInput.ppu8Plane[0] := IntPtr(pImgData);
  offInput.pi32Pitch[0] := iLineBytes;
  //offInput.pi32Pitch[1] := offInput.i32Width div 2;
  //offInput.pi32Pitch[2] := offInput.i32Width div 2;
  //�������
  if AFT_FSDK_FaceFeatureDetect(FFaceTrackingEngine, @offInput, pFaceRes)
    = MOK then
  begin
    ExtractFaceBoxs(pFaceRes^, AFaceRegions);
  end;

  if pImgData <> nil then
    FreeMem(pImgData);

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.DetectFacesFromBmpFile
 ����:      ���ļ�Bmp�ļ��л�ȡ����λ����Ϣ�б���ȷ���ļ�Ϊ��ȷ��BMP��ʽ
 ����:      Bird
 ����:      2017.09.24
 ����:      AFile: String; //Դ�ļ�
 var AFaceRegions: TList<AFR_FSDK_FACEINPUT> //��������λ����Ϣ�б�
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
function TArcFaceSDK.DetectFacesFromBmpFile(AFile: string; var AFaceRegions:
  TList<AFR_FSDK_FACEINPUT>): Boolean;
var
  BMP: TBitmap;
begin
  Result := False;
  if FFaceDetectionEngine = nil then
    Exit;

  if not FileExists(AFile) then
    Exit;
  BMP := TBitmap.Create;
  try
    BMP.LoadFromFile(AFile);
    Result := DetectFacesFromBmp(BMP, AFaceRegions);
  finally
    BMP.Free;
  end;
end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.TrackFacesFromBmpFile
 ����:      ���ļ��л�ȡ����λ����Ϣ�б�׷��ģʽ��
 ����:      Bird
 ����:      2017.09.24
 ����:      AFile: String; //Դ�ļ�
 var AFaceRegions: TList<AFR_FSDK_FACEINPUT> //�������λ����Ϣ
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
function TArcFaceSDK.TrackFacesFromBmpFile(AFile: string; var AFaceRegions:
  TList<AFR_FSDK_FACEINPUT>): Boolean;
var
  BMP: TBitmap;
begin
  Result := False;
  if FFaceTrackingEngine = nil then
    Exit;

  if not FileExists(AFile) then
    Exit;
  BMP := TBitmap.Create;
  try
    //�����ļ�
    BMP.LoadFromFile(AFile);
    //�������
    Result := TrackFacesFromBmp(BMP, AFaceRegions);
  finally
    BMP.Free;
  end;
end;

procedure TArcFaceSDK.DoLog(const Msg: String);
begin
  if Assigned(FOnLog) then
    FOnLog(Msg);
end;

{-------------------------------------------------------------------------------
  ������:    TArcFaceSDK.DRAGfromJPGFile
  ����:      ��JPG�ļ��л�ȡ����λ�á����䡢�Ա��������Ϣ�б�
  ����:      Bird
  ����:      2018.01.31
  ����:      AFileName: string; var AFaceInfos: TList<TFaceBaseInfo>; var AFaceModels: TFaceModels
  ����ֵ:    Boolean
-------------------------------------------------------------------------------}
function TArcFaceSDK.DRAGfromJPGFile(AFileName: string; var AFaceInfos:
  TList<TFaceBaseInfo>; var AFaceModels: TFaceModels): Boolean;
var
  lBitmap: TBitmap;
begin
  Result := False;
  if not FileExists(AFileName) then
    Exit;

  lBitmap := TBitmap.Create;
  try
    if ReadJpegFile(AFileName, lBitmap) then
      Result := DRAGfromBmp(lBitmap, AFaceInfos, AFaceModels);
  finally
    lBitmap.Free;
  end;
end;

{-------------------------------------------------------------------------------
  ������:    TArcFaceSDK.DRAGfromBmp
  ����:      ��Bitmap�л�ȡ����λ�á����䡢�Ա��������Ϣ�б�
  ����:      Bird
  ����:      2018.01.31
  ����:      ABitmap: TBitmap; var AFaceInfos: TList<TFaceBaseInfo>; var AFaceModels: TFaceModels
  ����ֵ:    Boolean
-------------------------------------------------------------------------------}
function TArcFaceSDK.DRAGfromBmp(ABitmap: TBitmap; var AFaceInfos:
  TList<TFaceBaseInfo>; var AFaceModels: TFaceModels): Boolean;
var
  pImgData: PByte;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
  lFaceRes_Age: ASAE_FSDK_AGEFACEINPUT;
  lFaceRes_Gender: ASGE_FSDK_GENDERFACEINPUT;
  nRet: MRESULT;
  lFaceRegions: TList<AFR_FSDK_FACEINPUT>;
  lAgeRes: ASAE_FSDK_AGERESULT;
  lGenderRes: ASGE_FSDK_GENDERRESULT;
  lAges: TArray<Integer>;
  lGenders: TArray<Integer>;
  lFaceInfo: TFaceBaseInfo;
  i, iFaces: Integer;
  iWidth, iHeight, iLineBytes: Integer;
  ArrFaceOrient: array of AFD_FSDK_OrientCode;
  ArrFaceRect: array of MRECT;
{$IFDEF DEBUG}
  T: Cardinal;
{$ENDIF}
begin
  Result := False;

  if AFaceInfos = nil then
    AFaceInfos := TList<TFaceBaseInfo>.Create;
  if AFaceModels = nil then
    AFaceModels := TFaceModels.Create;

  if FFaceDetectionEngine = nil then
    Exit;

  pImgData := nil;

{$IFDEF DEBUG}
  T := GetTickCount;
{$ENDIF}
  if not ReadBmp(ABitmap, pImgData, iWidth, iHeight, iLineBytes) then
    Exit;
{$IFDEF DEBUG}
  T := GetTickCount - T;
  DoLog('�������ݺ�ʱ��' + IntToStr(T));
{$ENDIF}
  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := iWidth;
  offInput.i32Height := iHeight;

  offInput.ppu8Plane[0] := IntPtr(pImgData);
  offInput.pi32Pitch[0] := iLineBytes;
  //�������
{$IFDEF DEBUG}
  T := GetTickCount;
{$ENDIF}
  nRet := AFD_FSDK_StillImageFaceDetection(FFaceDetectionEngine, @offInput,
    pFaceRes);
{$IFDEF DEBUG}
  DoLog('���������ʱ��' + IntToStr(GetTickCount - T));
{$ENDIF}
  if nRet = MOK then
  begin

    Result := true;

    lFaceRegions := TList<AFR_FSDK_FACEINPUT>.Create;
    try

      ExtractFaceBoxs(pFaceRes^, lFaceRegions);

      if lFaceRegions.Count > 0 then
      begin

        iFaces := lFaceRegions.Count;
        SetLength(ArrFaceOrient, iFaces);
        SetLength(ArrFaceRect, iFaces);
        for i := 0 to iFaces - 1 do
        begin
          ArrFaceOrient[i] := lFaceRegions.Items[i].lOrient;
          ArrFaceRect[i] := lFaceRegions.Items[i].rcFace;
        end;
        //===================================================
        //�������
        //===================================================
        if (FFaceAgeEngine <> nil) then
        begin
          with lFaceRes_Age do
          begin
            pFaceRectArray := @ArrFaceRect[0];
            pFaceOrientArray := @ArrFaceOrient[0];
            lFaceNumber := iFaces;
          end;

{$IFDEF DEBUG}
          T := GetTickCount;
{$ENDIF}
          if ASAE_FSDK_AgeEstimation_StaticImage(
            FFaceAgeEngine, //[in] age estimation engine
            @offInput, //[in] the original image information
            //[in] the face rectangles information
            @lFaceRes_Age,
            //[out] the results of age estimation
            lAgeRes
            ) = MOK then
            //�ֽ���������
            ExtractFaceAges(lAgeRes, lAges)
          else
            Result := False;
{$IFDEF DEBUG}
          DoLog('��������ʱ��' + IntToStr(GetTickCount - T));
{$ENDIF}
        end
        else
          Result := False;

        //===================================================
        //����Ա�
        //===================================================
        if (FFaceGenderEngine <> nil) then
        begin
          with lFaceRes_Gender do
          begin
            pFaceRectArray := @ArrFaceRect[0];
            pFaceOrientArray := @ArrFaceOrient[0];
            lFaceNumber := iFaces;
          end;

{$IFDEF DEBUG}
          T := GetTickCount;
{$ENDIF}
          if ASGE_FSDK_GenderEstimation_StaticImage(
            FFaceGenderEngine, //[in] Gender estimation engine
            @offInput, //[in] the original imGender information
            //[in] the face rectangles information
            @lFaceRes_Gender,
            //[out] the results of Gender estimation
            lGenderRes
            ) = MOK then
            //�ֽ������Ա�
            ExtractFaceGenders(lGenderRes, lGenders)
          else
            Result := False;
{$IFDEF DEBUG}
          DoLog('����Ա��ʱ��' + IntToStr(GetTickCount - T));
{$ENDIF}
        end
        else
          Result := False;

        for i := 0 to iFaces - 1 do
        begin
          lFaceInfo.Init;
          lFaceInfo.FaceRect := ArrFaceRect[i];
          lFaceInfo.FaceOrient := ArrFaceOrient[i];
          if i < Length(lAges) then
            lFaceInfo.Age := lAges[i];
          if i < Length(lGenders) then
            lFaceInfo.Gender := lGenders[i];
          AFaceInfos.Add(lFaceInfo);
        end;


        //===================================================
        //��ȡ����
        //===================================================

{$IFDEF DEBUG}
        T := GetTickCount;
{$ENDIF}
        if not ExtractFaceFeatures(offInput, lFaceRegions, AFaceModels) then
          Result := False;
{$IFDEF DEBUG}
        DoLog('��ȡ������ʱ��' + IntToStr(GetTickCount - T));
{$ENDIF}
      end;

    finally
      lFaceRegions.Free;
    end;
  end;

  if pImgData <> nil then
    FreeMem(pImgData);

end;


{-------------------------------------------------------------------------------
  ������:    TArcFaceSDK.DRAGfromBmpFile
  ����:      ��BMP�ļ��л�ȡ����λ�á����䡢�Ա��������Ϣ�б�
  ����:      Bird
  ����:      2018.01.31
  ����:      AFileName: string; var AFaceInfos: TList<TFaceBaseInfo>; var AFaceModels: TFaceModels
  ����ֵ:    Boolean
-------------------------------------------------------------------------------}
function TArcFaceSDK.DRAGfromBmpFile(AFileName: string; var AFaceInfos:
  TList<TFaceBaseInfo>; var AFaceModels: TFaceModels): Boolean;
var
  lBitmap: TBitmap;
begin
  Result := False;
  if not FileExists(AFileName) then
    Exit;

  lBitmap := TBitmap.Create;
  try
    if ReadBmpFile(AFileName, lBitmap) then
      Result := DRAGfromBmp(lBitmap, AFaceInfos, AFaceModels);
  finally
    lBitmap.Free;
  end;
end;


{-------------------------------------------------------------------------------
  ������:    TArcFaceSDK.DrawFaceRectAgeGender
  ����:      ��Canvas�ϻ����������䡢�Ա�
  ����:      Bird
  ����:      2018.01.31
  ����:      ACanvas: TCanvas; AFaceIdx: Integer; AFaceInfo: TFaceBaseInfo; AColor: TColor = clBlue; AWidth: Integer = 2; ADrawIndex: Boolean = true; ATextSize: Integer = 0
  ����ֵ:    ��
-------------------------------------------------------------------------------}
class procedure TArcFaceSDK.DrawFaceRectAgeGender(ACanvas: TCanvas; AFaceIdx:
  Integer; AFaceInfo: TFaceBaseInfo; AColor: TColor = clBlue; AWidth: Integer
  = 2; ADrawIndex: Boolean = true; ATextSize: Integer = 0);
var
  sText: string;
  iTextHeight, iTextWidth: Integer;
begin
  ATextSize := 0;
  ACanvas.Pen.Color := AColor;
  ACanvas.Pen.Width := AWidth;
  ACanvas.Brush.Style := bsClear;
  if ATextSize = 0 then
    ACanvas.Font.Size :=
      Round((AFaceInfo.FaceRect.bottom - AFaceInfo.FaceRect.top) / (10 * 1.5))
  else
    ACanvas.Font.Size := ATextSize;
  ACanvas.Font.Color := AColor;
  ACanvas.RoundRect(AFaceInfo.FaceRect.left,
    AFaceInfo.FaceRect.top,
    AFaceInfo.FaceRect.right, AFaceInfo.FaceRect.bottom, 0, 0);

  sText := '';
  case AFaceInfo.Gender of
    0:
      sText := '�Ա�:��';
    1:
      sText := '�Ա�:Ů';
  else
    sText := '�Ա�:δ֪';
  end;

  sText := sText + ' ����:' + IntToStr(AFaceInfo.Age);

  if ADrawIndex then
  begin
    if AFaceIdx <> -1 then
      sText := IntToStr(AFaceIdx) + ' ' + sText;
  end;

  if sText <> '' then
  begin
    iTextWidth := ACanvas.TextWidth(sText);
    iTextHeight := ACanvas.TextHeight(sText);

    ACanvas.Brush.Style := bsSolid;
    ACanvas.Brush.Color := AColor;
    if ACanvas.Brush.Color = clWhite then
      ACanvas.Font.Color := clBlack
    else
      ACanvas.Font.Color := clWhite;
    ACanvas.Font.Quality := fqClearType;

    ACanvas.RoundRect(AFaceInfo.FaceRect.left,
      AFaceInfo.FaceRect.top - iTextHeight - 6,
      Max(AFaceInfo.FaceRect.right,
      AFaceInfo.FaceRect.left + iTextWidth + 10),
      AFaceInfo.FaceRect.top, 0, 0);

    ACanvas.TextOut(AFaceInfo.FaceRect.left + 5,
      AFaceInfo.FaceRect.top - 3 - iTextHeight, sText);
  end;

  ACanvas.Refresh;

end;


{-------------------------------------------------------------------------------
  ������:    TArcFaceSDK.DrawFaceRect
  ����:      ��Canvas�ϻ�������
  ����:      Bird
  ����:      2018.01.31
  ����:      ACanvas: TCanvas; AFaceIdx: Integer; AFaceInfo: AFR_FSDK_FACEINPUT; AColor: TColor = clBlue; AWidth: Integer = 2; ADrawIndex: Boolean = true; ATextSize: Integer = 0
  ����ֵ:    ��
-------------------------------------------------------------------------------}
class procedure TArcFaceSDK.DrawFaceRect(ACanvas: TCanvas; AFaceIdx: Integer;
  AFaceInfo: AFR_FSDK_FACEINPUT; AColor: TColor = clBlue; AWidth: Integer =
  2; ADrawIndex: Boolean = true; ATextSize: Integer = 0);
var
  sText: string;
  iTextHeight, iTextWidth: Integer;
begin
  ATextSize := 0;
  ACanvas.Pen.Color := AColor;
  ACanvas.Pen.Width := AWidth;
  ACanvas.Brush.Style := bsClear;
  if ATextSize = 0 then
    ACanvas.Font.Size :=
      Round((AFaceInfo.rcFace.bottom - AFaceInfo.rcFace.top) / (10 * 1.5))
  else
    ACanvas.Font.Size := ATextSize;
  ACanvas.Font.Color := AColor;
  ACanvas.RoundRect(AFaceInfo.rcFace.left,
    AFaceInfo.rcFace.top,
    AFaceInfo.rcFace.right, AFaceInfo.rcFace.bottom, 0, 0);

  sText := '';
  if ADrawIndex then
  begin
    if AFaceIdx <> -1 then
      sText := IntToStr(AFaceIdx);
  end;

  if sText <> '' then
  begin
    iTextWidth := ACanvas.TextWidth(sText);
    iTextHeight := ACanvas.TextHeight(sText);

    ACanvas.Brush.Style := bsSolid;
    ACanvas.Brush.Color := AColor;
    if ACanvas.Brush.Color = clWhite then
      ACanvas.Font.Color := clBlack
    else
      ACanvas.Font.Color := clWhite;
    ACanvas.Font.Quality := fqClearType;

    ACanvas.RoundRect(AFaceInfo.rcFace.left,
      AFaceInfo.rcFace.top - iTextHeight - 6,
      Max(AFaceInfo.rcFace.right,
      AFaceInfo.rcFace.left + iTextWidth + 10),
      AFaceInfo.rcFace.top, 0, 0);

    ACanvas.TextOut(Round((AFaceInfo.rcFace.left - iTextWidth) /
      2), AFaceInfo.rcFace.top - 3 - iTextHeight, sText);

  end;

  ACanvas.Refresh;

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.ExtractFaceBoxs
 ����:      ��ȡAPI����������б�Delphi�����б�(����ģʽ)
 ����:      Bird
 ����:      2018.01.19
 ����:      AFaces: AFT_FSDK_FACERES;//����λ�ÿ�ԭʼ����
 var AFaceRegions: TList<AFR_FSDK_FACEINPUT> //�ֽ�����б�
 ����ֵ:    ��
 -------------------------------------------------------------------------------}
class procedure TArcFaceSDK.ExtractFaceBoxs(AFaces: AFT_FSDK_FACERES; var
  AFaceRegions: TList<AFR_FSDK_FACEINPUT>);
var
  i, j: Integer;
  lFace: AFR_FSDK_FACEINPUT;
begin
  //if AFaceRegions = nil then
  //AFaceRegions := TList<AFR_FSDK_FACEINPUT>.Create;
  j := SizeOf(Integer);
  for i := 0 to AFaces.nFace - 1 do
  begin
    lFace.rcFace := pmrect(AFaces.rcFace + i * SizeOf(MRECT))^;
    //if AFaces.lfaceOrient < 100 then
    lFace.lOrient := AFaces.lfaceOrient;
    //else
    //lFace.lOrient := Pint(AFaces.lfaceOrient + i * j)^;
    AFaceRegions.Add(lFace);
  end;
end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.ExtractFaceBoxs
 ����:      ��ȡAPI����������б�Delphi�����б�
 ����:      Bird
 ����:      2017.11.19
 ����:      AFaces: AFD_FSDK_FACERES; //����λ�ÿ�ԭʼ����
 var AFaceRegions: TList<AFR_FSDK_FACEINPUT>//�ֽ�����б�
 ����ֵ:    ��
 -------------------------------------------------------------------------------}
class procedure TArcFaceSDK.ExtractFaceBoxs(AFaces: AFD_FSDK_FACERES;
  AFaceRegions: TList<AFR_FSDK_FACEINPUT>);
var
  i, j: Integer;
  lFace: AFR_FSDK_FACEINPUT;
begin
  //if AFaceRegions = nil then
  //AFaceRegions := TList<AFR_FSDK_FACEINPUT>.Create;
  j := SizeOf(AFD_FSDK_OrientCode);
  for i := 0 to AFaces.nFace - 1 do
  begin
    lFace.rcFace := pmrect(AFaces.rcFace + i * SizeOf(MRECT))^;
    lFace.lOrient := Pint(AFaces.lfaceOrient + i * j)^;
    AFaceRegions.Add(lFace);
  end;
end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.ExtractFaceAges
 ����:      ��ȡAPI�������������б�����
 ����:      Bird
 ����:      2017.12.17
 ����:      AFaceAgeResults: ASAE_FSDK_AGERESULT; //���g�����
 var AFaceAges: TArray<Integer> //�����������
 ����ֵ:    ��
 -------------------------------------------------------------------------------}
class procedure TArcFaceSDK.ExtractFaceAges(AFaceAgeResults:
  ASAE_FSDK_AGERESULT; var AFaceAges: TArray<Integer>);
var
  i, j: Integer;
begin
  j := SizeOf(MInt32);
  SetLength(AFaceAges, AFaceAgeResults.lFaceNumber);
  for i := 0 to AFaceAgeResults.lFaceNumber - 1 do
    AFaceAges[i] := Pint(AFaceAgeResults.pAgeResultArray + i * j)^;
end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.ExtractFaceAges
 ����:      ��ȡAPI�����Ա������б�����
 ����:      Bird
 ����:      2017.12.17
 ����:      AFaceGenderResults: ASGE_FSDK_GENDERRESULT; //�Ա�����
 var AFaceGenders: TArray<Integer> //�����������
 ����ֵ:    ��
 -------------------------------------------------------------------------------}
class procedure TArcFaceSDK.ExtractFaceGenders(AFaceGenderResults:
  ASGE_FSDK_GENDERRESULT; var AFaceGenders: TArray<Integer>);
var
  i, j: Integer;
begin
  j := SizeOf(Integer);
  SetLength(AFaceGenders, AFaceGenderResults.lFaceNumber);
  for i := 0 to AFaceGenderResults.lFaceNumber - 1 do
  begin
    AFaceGenders[i] := Pint(AFaceGenderResults.pGenderResultArray + (i * j))^;
  end;
end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.ExtractFaceFeature
 ����:      ���ݸ����ĵ�����������ȡ������������
 ����:      Bird
 ����:      2017.09.24
 ����:      AFaceInput: ASVLOFFSCREEN; //ͼƬ����
 AFaceRegion: AFR_FSDK_FACEINPUT; //����λ����Ϣ
 var AFaceModel: AFR_FSDK_FACEMODEL //�������������������ڴ����ֶ�ʹ��freemem�ͷ�
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
function TArcFaceSDK.ExtractFaceFeature(AFaceInput: ASVLOFFSCREEN; AFaceRegion:
  AFR_FSDK_FACEINPUT; var AFaceModel: AFR_FSDK_FACEMODEL): Boolean;
var
  tmpFaceModels: AFR_FSDK_FACEMODEL;
begin
  Result := False;
  if FFaceRecognitionEngine = nil then
    Exit;

  with AFaceModel do
  begin
    pbFeature := nil; //The extracted features
    lFeatureSize := 0;
  end;

  with tmpFaceModels do
  begin
    pbFeature := nil; //The extracted features
    lFeatureSize := 0;
  end;

  //��ȡ��������
  Result := AFR_FSDK_ExtractFRFeature(FFaceRecognitionEngine, @AFaceInput,
    @AFaceRegion, tmpFaceModels) = MOK;
  if Result then
  begin
    AFaceModel.lFeatureSize := tmpFaceModels.lFeatureSize;
    GetMem(AFaceModel.pbFeature, AFaceModel.lFeatureSize);
    CopyMemory(AFaceModel.pbFeature, tmpFaceModels.pbFeature,
      AFaceModel.lFeatureSize);
  end;

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.ExtractFaceFeatures
 ����:      ���ݸ����Ķ����������ȡ�����������
 ����:      Bird
 ����:      2017.09.24
 ����:      AFaceInput: ASVLOFFSCREEN; //ͼƬ����
 AFaceRegions: TList<AFR_FSDK_FACEINPUT>; //����λ����Ϣ��Ϣ�б�
 var AFaceModels: TFaceModels //������������б�
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
function TArcFaceSDK.ExtractFaceFeatures(AFaceInput: ASVLOFFSCREEN;
  AFaceRegions: TList<AFR_FSDK_FACEINPUT>; var AFaceModels: TFaceModels):
  Boolean;
var
  lFaceModel: AFR_FSDK_FACEMODEL;
  i: Integer;
begin
  Result := False;
  if FFaceRecognitionEngine = nil then
    Exit;

  if AFaceModels = nil then
    AFaceModels := TFaceModels.Create;

  for i := 0 to AFaceRegions.Count - 1 do
    if ExtractFaceFeature(AFaceInput, AFaceRegions.Items[i], lFaceModel) then
      AFaceModels.AddModel(lFaceModel);
  Result := true;

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.ExtractFaceFeatureFromBmp
 ����:      ��Bitmap����ȡ������������
 ����:      Bird
 ����:      2017.09.24
 ����:      ABitmap: TBitmap; //Bitmap����
 AFaceRegion: AFR_FSDK_FACEINPUT; //����λ����Ϣ
 var AFaceModel: AFR_FSDK_FACEMODEL //�������������������ڴ����ֶ�ʹ��freemem�ͷ�
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
function TArcFaceSDK.ExtractFaceFeatureFromBmp(ABitmap: TBitmap; AFaceRegion:
  AFR_FSDK_FACEINPUT; var AFaceModel: AFR_FSDK_FACEMODEL): Boolean;
var
  pImgData: PByte;
  iWidth, iHeight, iLineBytes: Integer;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
begin
  Result := False;

  if FFaceRecognitionEngine = nil then
    Exit;

  pImgData := nil;

  if not ReadBmp(ABitmap, pImgData, iWidth, iHeight, iLineBytes) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);
  offInput.i32Width := iWidth;
  offInput.i32Height := iHeight;

  offInput.ppu8Plane[0] := IntPtr(pImgData);
  offInput.pi32Pitch[0] := iLineBytes;

  //����������ȡ
  Result := ExtractFaceFeature(offInput, AFaceRegion, AFaceModel);

  if pImgData <> nil then
    FreeMem(pImgData);

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.ExtractFaceFeaturesFromBmp
 ����:      ��Bitmap����ȡ�����������
 ����:      Bird
 ����:      2017.09.24
 ����:      ABitmap: TBitmap; //ͼƬ����
 AFaceRegions: TList<AFR_FSDK_FACEINPUT>; //����λ����Ϣ��Ϣ�б�
 var AFaceModels: TFaceModels //������������б�
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
function TArcFaceSDK.ExtractFaceFeaturesFromBmp(ABitmap: TBitmap; AFaceRegions:
  TList<AFR_FSDK_FACEINPUT>; var AFaceModels: TFaceModels): Boolean;
var
  pImgData: PByte;
  iWidth, iHeight, iLineBytes: Integer;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
begin
  Result := False;

  if FFaceRecognitionEngine = nil then
    Exit;

  pImgData := nil;

  if not ReadBmp(ABitmap, pImgData, iWidth, iHeight, iLineBytes) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);
  offInput.i32Width := iWidth;
  offInput.i32Height := iHeight;

  offInput.ppu8Plane[0] := IntPtr(pImgData);
  offInput.pi32Pitch[0] := iLineBytes;

  //����������ȡ
  Result := ExtractFaceFeatures(offInput, AFaceRegions, AFaceModels);

  if pImgData <> nil then
    FreeMem(pImgData);

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.ExtractFaceFeatureFromBmpFile
 ����:      ��BMP�ļ�����ȡ������������
 ����:      Bird
 ����:      2017.09.24
 ����:
 AFile: string; //BMPͼƬ�ļ�����ȷ���ļ���ʽΪBMP
 AFaceRegion: AFR_FSDK_FACEINPUT; //����λ����Ϣ
 var AFaceModel: AFR_FSDK_FACEMODEL //�������������������ڴ����ֶ�ʹ��freemem�ͷ�
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
function TArcFaceSDK.ExtractFaceFeatureFromBmpFile(AFile: string; AFaceRegion:
  AFR_FSDK_FACEINPUT; var AFaceModel: AFR_FSDK_FACEMODEL): Boolean;
var
  pImgData: PByte;
  iWidth, iHeight, iLineBytes: Integer;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
begin
  Result := False;

  if FFaceRecognitionEngine = nil then
    Exit;

  pImgData := nil;

  if not ReadBmpFile(AFile, pImgData, iWidth, iHeight, iLineBytes) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);
  offInput.i32Width := iWidth;
  offInput.i32Height := iHeight;

  offInput.ppu8Plane[0] := IntPtr(pImgData);
  offInput.pi32Pitch[0] := iLineBytes;

  //����������ȡ
  Result := ExtractFaceFeature(offInput, AFaceRegion, AFaceModel);

  if pImgData <> nil then
    FreeMem(pImgData);

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.ExtractFaceFeaturesFromBmpFile
 ����:      ��BMP�ļ�����ȡ�����������
 ����:      Bird
 ����:      2017.09.24
 ����:
 AFile: string; //BMPͼƬ�ļ�
 AFaceRegions: TList<AFR_FSDK_FACEINPUT>; //����λ����Ϣ��Ϣ�б�
 var AFaceModels: TFaceModels //���������б�
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
function TArcFaceSDK.ExtractFaceFeaturesFromBmpFile(AFile: string;
  AFaceRegions: TList<AFR_FSDK_FACEINPUT>; var AFaceModels: TFaceModels):
  Boolean;
var
  pImgData: PByte;
  iWidth, iHeight, iLineBytes: Integer;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFD_FSDK_FACERES;
begin
  Result := False;

  if FFaceRecognitionEngine = nil then
    Exit;

  pImgData := nil;

  if not ReadBmpFile(AFile, pImgData, iWidth, iHeight, iLineBytes) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);
  offInput.i32Width := iWidth;
  offInput.i32Height := iHeight;

  offInput.ppu8Plane[0] := IntPtr(pImgData);
  offInput.pi32Pitch[0] := iLineBytes;

  //����������ȡ
  Result := ExtractFaceFeatures(offInput, AFaceRegions, AFaceModels);

  if pImgData <> nil then
    FreeMem(pImgData);

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.InitialFaceDetectionEngine
 ����:      ��ʼ�������������
 ����:      Bird
 ����:      2017.11.19
 ����:      Deinitial: Boolean
 ����ֵ:    Integer
 -------------------------------------------------------------------------------}
function TArcFaceSDK.InitialFaceDetectionEngine(Deinitial: Boolean): Integer;
begin

  if FFaceDetectionEngine <> nil then
  begin
    if Deinitial then
    begin
      //�ͷ�����
      Result := UnInitialFaceDetectionEngine;
      if Result <> MOK then
        Exit;
    end
    else
    begin
      Result := MOK;
      Exit;
    end;
  end;

  GetMem(FpFaceDetectionBuf, FWorkKBufferSize);
  //��ʼ������
  Result := AFD_FSDK_InitialFaceEngine(
    pansichar(AnsiString(FAppID)), //[in]  APPID
    pansichar(AnsiString(FFaceDetectionKey)), //[in]  SDKKEY
    FpFaceDetectionBuf, //[in]	 User allocated memory for the engine
    FWorkKBufferSize, //WORKBUF_SIZE, //[in]	 User allocated memory size
    FFaceDetectionEngine, //[out] Pointing to the detection engine.
    //[in]  Defining the priority of face orientation
    ord(FOrientPriority),
    //[in]  An integer defining the minimal face to detect relative to the maximum of image width and height.
    FScale,
    //[in]  An integer defining the number of max faces to detection
    FMaxFace
    );

  if Result <> MOK then
  begin
    FreeMem(FpFaceDetectionBuf);
    FpFaceDetectionBuf := nil;
  end;

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.InitialFaceTrackingEngine
 ����:      ��ʼ������׷������
 ����:      Bird
 ����:      2017.11.19
 ����:      Deinitial: Boolean
 ����ֵ:    Integer
 -------------------------------------------------------------------------------}
function TArcFaceSDK.InitialFaceTrackingEngine(Deinitial: Boolean): Integer;
begin

  if FFaceTrackingEngine <> nil then
  begin
    if Deinitial then
    begin
      Result := UnInitialFaceTrackingEngine;
      if Result <> MOK then
        Exit;
    end
    else
    begin
      Result := MOK;
      Exit;
    end;
  end;

  GetMem(FpFaceTrackingBuf, FWorkKBufferSize);
  //��ʼ��
  Result := AFT_FSDK_InitialFaceEngine(
    pansichar(AnsiString(FAppID)), //[in]  APPID
    pansichar(AnsiString(FFaceTrackingKey)), //[in]  SDKKEY
    FpFaceTrackingBuf, //[in]	 User allocated memory for the engine
    FWorkKBufferSize, //WORKBUF_SIZE, //[in]	 User allocated memory size
    FFaceTrackingEngine, //[out] Pointing to the Tracking engine.
    //[in]  Defining the priority of face orientation
    ord(FOrientPriority),
    //[in]  An integer defining the minimal face to detect relative to the maximum of image width and height.
    FScale,
    //[in]  An integer defining the number of max faces to Tracking
    FMaxFace
    );
  if Result <> MOK then
  begin
    FreeMem(FpFaceTrackingBuf);
    FpFaceTrackingBuf := nil;
  end;

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.InitialFaceRecognitionEngine
 ����:      ��ʼ�����������������
 ����:      Bird
 ����:      2017.11.19
 ����:      Deinitial: Boolean
 ����ֵ:    Integer
 -------------------------------------------------------------------------------}
function TArcFaceSDK.InitialFaceRecognitionEngine(Deinitial: Boolean): Integer;
begin

  if FFaceRecognitionEngine <> nil then
  begin
    if Deinitial then
    begin
      Result := UnInitialFaceRecognitionEngine;
      if Result <> MOK then
        Exit;
    end
    else
    begin
      Result := MOK;
      Exit;
    end;
  end;

  GetMem(FpFaceRecognitionBuf, FWorkKBufferSize);
  Result := AFR_FSDK_InitialEngine(
    pansichar(AnsiString(FAppID)), //[in]  APPID
    pansichar(AnsiString(FFaceRecognitionKey)), //[in]  SDKKEY
    FpFaceRecognitionBuf, //[in]	 User allocated memory for the engine
    FWorkKBufferSize, //WORKBUF_SIZE, //[in]	 User allocated memory size
    FFaceRecognitionEngine
    );

  if Result <> MOK then
  begin
    FreeMem(FpFaceRecognitionBuf);
    FpFaceRecognitionBuf := nil;
  end;

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.InitialFaceAgeEngine
 ����:      ��ʼ����������������
 ����:      Bird
 ����:      2017.11.19
 ����:      Deinitial: Boolean
 ����ֵ:    Integer
 -------------------------------------------------------------------------------}
function TArcFaceSDK.InitialFaceAgeEngine(Deinitial: Boolean): Integer;
begin

  if FFaceAgeEngine <> nil then
  begin
    if Deinitial then
    begin
      Result := UnInitialFaceAgeEngine;
      if Result <> MOK then
        Exit;
    end
    else
    begin
      Result := MOK;
      Exit;
    end;
  end;

  GetMem(FpFaceAgeBuf, FEstimationBufferSize);
  Result := ASAE_FSDK_InitAgeEngine(
    pansichar(AnsiString(FAppID)), //[in]  APPID
    pansichar(AnsiString(FFaceAgeKey)), //[in]  SDKKEY
    FpFaceAgeBuf, //[in]	 User allocated memory for the engine
    FEstimationBufferSize, //WORKBUF_SIZE, //[in]	 User allocated memory size
    FFaceAgeEngine
    );

  if Result <> MOK then
  begin
    FreeMem(FpFaceAgeBuf);
    FpFaceAgeBuf := nil;
  end;

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.InitialFaceGenderEngine
 ����:      ��ʼ�������Ա�������
 ����:      Bird
 ����:      2017.11.19
 ����:      Deinitial: Boolean
 ����ֵ:    Integer
 -------------------------------------------------------------------------------}
function TArcFaceSDK.InitialFaceGenderEngine(Deinitial: Boolean): Integer;
begin

  if FFaceGenderEngine <> nil then
  begin
    if Deinitial then
    begin
      Result := UnInitialFaceGenderEngine;
      if Result <> MOK then
        Exit;
    end
    else
    begin
      Result := MOK;
      Exit;
    end;
  end;

  GetMem(FpFaceGenderBuf, FEstimationBufferSize);
  Result := ASGE_FSDK_InitGenderEngine(
    pansichar(AnsiString(FAppID)), //[in]  APPID
    pansichar(AnsiString(FFaceGenderKey)), //[in]  SDKKEY
    FpFaceGenderBuf, //[in]	 User allocated memory for the engine
    FEstimationBufferSize, //WORKBUF_SIZE, //[in]	 User allocated memory size
    FFaceGenderEngine
    );

  if Result <> MOK then
  begin
    FreeMem(FpFaceGenderBuf);
    FpFaceGenderBuf := nil;
  end;

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.MatchFace
 ����:      �ȶ�������������
 ����:      Bird
 ����:      2017.11.19
 ����:      AFaceModel1, AFaceModel2: AFR_FSDK_FACEMODEL
 ����ֵ:    Single
 -------------------------------------------------------------------------------}
function TArcFaceSDK.MatchFace(AFaceModel1, AFaceModel2: AFR_FSDK_FACEMODEL):
  Single;
var
  fSimilScore: MFloat;
begin
  Result := 0;
  if FFaceRecognitionEngine = nil then
    Exit;

  //�Ա�����������������ñȶԽ��
  fSimilScore := 0.0;
  if AFR_FSDK_FacePairMatching(FFaceRecognitionEngine, @AFaceModel1,
    @AFaceModel2, fSimilScore) = MOK then
    Result := fSimilScore;
end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.MatchFaceWithBitmaps
 ����:      �ȶ�����ͼ��ֻȡ����ͼ��ĵ�һ���������бȶԣ�
 ����:      Bird
 ����:      2017.11.19
 ����:      ABitmap1, ABitmap2: TBitmap
 ����ֵ:    Single
 -------------------------------------------------------------------------------}
function TArcFaceSDK.MatchFaceWithBitmaps(ABitmap1, ABitmap2: TBitmap): Single;
var
  AFaceRegions1, AFaceRegions2: TList<AFR_FSDK_FACEINPUT>;
  AFaceModels1, AFaceModels2: TFaceModels;
  i: Integer;
  T: Cardinal;
begin
  Result := 0;
  if (ABitmap1 = nil) or (ABitmap2 = nil) then
    Exit;

  AFaceRegions1 := TList<AFR_FSDK_FACEINPUT>.Create;
  AFaceRegions2 := TList<AFR_FSDK_FACEINPUT>.Create;
  AFaceModels1 := TFaceModels.Create;
  AFaceModels2 := TFaceModels.Create;
  try
{$IFDEF DEBUG}
    T := GetTickCount;
{$ENDIF}
    DetectAndRecognitionFacesFromBmp(ABitmap1, AFaceRegions1,
      AFaceModels1);
{$IFDEF DEBUG}
    T := GetTickCount - T;
    DoLog('ȡͼһ������ʱ��' + IntToStr(T));
{$ENDIF}

{$IFDEF DEBUG}
    T := GetTickCount;
{$ENDIF}
    DetectAndRecognitionFacesFromBmp(ABitmap2, AFaceRegions2,
      AFaceModels2);
{$IFDEF DEBUG}
    T := GetTickCount - T;
    DoLog('ȡͼ��������ʱ��' + IntToStr(T));
{$ENDIF}
    if (AFaceModels1.Count > 0) and (AFaceModels2.Count > 0) then
    begin
{$IFDEF DEBUG}
      T := GetTickCount;
{$ENDIF}
      Result := MatchFace(AFaceModels1.FaceModel[0],
        AFaceModels2.FaceModel[0]);
{$IFDEF DEBUG}
      T := GetTickCount - T;
      DoLog('�ȶԺ�ʱ��' + IntToStr(T));
{$ENDIF}
    end;

  finally
    AFaceRegions1.Free;
    AFaceRegions2.Free;
    AFaceModels1.Free;
    AFaceModels2.Free;
  end;

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.UnInitialFaceDetectionEngine
 ����:      �ͷ������������
 ����:      Bird
 ����:      2017.09.24
 ����:      ��
 ����ֵ:    Integer
 -------------------------------------------------------------------------------}
function TArcFaceSDK.UnInitialFaceDetectionEngine: Integer;
begin

  if FFaceDetectionEngine <> nil then
  begin
    Result := AFD_FSDK_UninitialFaceEngine(FFaceDetectionEngine);
    if Result = MOK then
      FFaceDetectionEngine := nil;
  end
  else
    Result := MOK;

  if FpFaceDetectionBuf <> nil then
  begin
    FreeMem(FpFaceDetectionBuf);
    FpFaceDetectionBuf := nil;
  end;

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.ReadBmp
 ����:      ��ȡBitmap���ڴ�
 ����:      Bird
 ����:      2017.11.19
 ����:      ABitmap: TBitmap; var AImgData: PByte; var AWidth, AHeight, ALineBytes: Integer
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
class function TArcFaceSDK.ReadBmp(ABitmap: TBitmap; var AImgData: PByte; var
  AWidth, AHeight, ALineBytes: Integer): Boolean;
var
  iLineByte: Integer;
  iBitCount: Integer;
  i: Integer;
  //��ȡλ��
  function GetBitCount: Integer;
  begin
    case ABitmap.PixelFormat of
      pf1bit:
        Result := 1;
      pf4bit:
        Result := 4;
      pf8bit:
        Result := 8;
      pf15bit:
        Result := 16;
      pf16bit:
        Result := 16;
      pf24bit:
        Result := 24;
      pf32bit:
        Result := 32;
    else
      Result := 0;
    end;
  end;

begin
  Result := False;
  iBitCount := GetBitCount;
  if iBitCount = 0 then
    Exit;

  AWidth := ABitmap.Width;
  AHeight := ABitmap.Height;

  //��ȡλͼ�г���
  iLineByte := Trunc((ABitmap.Width * iBitCount / 8 + 3) / 4) * 4;
  ALineBytes := iLineByte;

  GetMem(AImgData, iLineByte * ABitmap.Height);

  //�����ڴ棬ע��Ϊ���򣬴����һ�п�ʼ��
  for i := ABitmap.Height - 1 downto 0 do
  begin
    CopyMemory(Pointer(AImgData + i * iLineByte), ABitmap.ScanLine[i],
      iLineByte);
  end;

  Result := true;
end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.ReadBmpFile
 ����:      ��ȡ�����ϵ�BMP�ļ����ڴ�
 ����:      Bird
 ����:      2017.11.19
 ����:      AFilename: string; var AImgData: PByte; var AWidth, AHeight, ALineBytes: Integer
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
class function TArcFaceSDK.ReadBmpFile(AFileName: string; var AImgData: PByte;
  var AWidth, AHeight, ALineBytes: Integer): Boolean;
var
  lBitmap: TBitmap;
begin

  Result := False;
  if not FileExists(AFileName) then
    Exit;

  lBitmap := TBitmap.Create;
  try
    lBitmap.LoadFromFile(AFileName);
    Result := ReadBmp(lBitmap, AImgData, AWidth, AHeight, ALineBytes);
  finally
    lBitmap.Free;
  end;

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.ReadBmpFile
 ����:      ��ȡ�����ϵ�BMP�ļ����ڴ�
 ����:      Bird
 ����:      2017.11.19
 ����:      AFilename: string; var ABitmap: PByte; var AWidth, AHeight, ALineBytes: Integer
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
class function TArcFaceSDK.ReadBmpFile(AFileName: string; ABitmap: TBitmap):
  Boolean;
begin

  Result := False;
  if not FileExists(AFileName) then
    Exit;

  ABitmap.LoadFromFile(AFileName);
  Result := true;

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.ReadJpegFile
 ����:      ��ȡ�����ϵ�JPG�ļ����ڴ沢ת��ΪTBitmap
 ����:      Bird
 ����:      2017.11.19
 ����:      AFilename: string; var AImgData: PByte; var AWidth, AHeight, ABitCount: Integer
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
class function TArcFaceSDK.ReadJpegFile(AFileName: string; var AImgData: PByte;
  var AWidth, AHeight, ABitCount: Integer): Boolean;
var
  lBitmap: TBitmap;
  lJpeg: TuJpegImage;
begin

  Result := False;
  if not FileExists(AFileName) then
    Exit;
  lJpeg := TuJpegImage.Create;

  try
    lJpeg.LoadFromFile(AFileName);
    lBitmap := lJpeg.BitmapData;
    Result := ReadBmp(lBitmap, AImgData, AWidth, AHeight, ABitCount);
  finally
    lBitmap := nil;
    lJpeg.Free;
  end;

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.ReadBmpStream
 ����:      ��ȡBMP��
 ����:      Bird
 ����:      2017.11.19
 ����:      AStream: TMemoryStream; var AImgData: PByte; var AWidth, AHeight, ALineBytes: Integer
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
class function TArcFaceSDK.ReadBmpStream(AStream: TMemoryStream; var AImgData:
  PByte; var AWidth, AHeight, ALineBytes: Integer): Boolean;
var
  lBitmap: TBitmap;
begin

  Result := False;
  if AStream = nil then
    Exit;

  lBitmap := TBitmap.Create;
  try
    lBitmap.LoadFromStream(AStream);
    Result := ReadBmp(lBitmap, AImgData, AWidth, AHeight, ALineBytes);
  finally
    lBitmap.Free;
  end;

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.ReadJpegFile
 ����:      ��ȡ�����ϵ�JPG�ļ����ڴ沢ת��ΪTBitmap
 ����:      Bird
 ����:      2017.11.19
 ����:      AFilename: string; var ABitmap: PByte; var AWidth, AHeight, ABitCount: Integer
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
class function TArcFaceSDK.ReadJpegFile(AFileName: string; ABitmap: TBitmap):
  Boolean;
var
  lJpeg: TuJpegImage;
begin

  Result := False;
  if not FileExists(AFileName) then
    Exit;
  lJpeg := TuJpegImage.Create;
  try
    lJpeg.LoadFromFile(AFileName);
    ABitmap.Assign(lJpeg.BitmapData);
    Result := true;
  finally
    lJpeg.Free;
  end;

end;

procedure TArcFaceSDK.SetMaxFace(const Value: Integer);
begin
  FMaxFace := Value;
end;

procedure TArcFaceSDK.SetScale(const Value: Integer);
begin
  FScale := Value;
end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.TrackFacesAndAgeGenderFromIEBitmap
 ����:      ��IEBitmap�л�ȡ����λ�á��Ա��������Ϣ�б�׷��ģʽ��
 ����:      DelphiDX10
 ����:      2018.01.31
 ����:      ABitmap: TIEBitmap; var AFaceInfos: TList<TFaceBaseInfo>; AUseCache: Boolean
 ����ֵ:    Boolean
 -------------------------------------------------------------------------------}
function TArcFaceSDK.TrackFacesAndAgeGenderFromBmp(ABitmap: TBitmap; var
  AFaceInfos: TList<TFaceBaseInfo>): Boolean;
var
  pImgData: PByte;
  offInput: ASVLOFFSCREEN;
  pFaceRes: LPAFT_FSDK_FACERES;
  lFaceRes_Age: ASAE_FSDK_AGEFACEINPUT;
  lFaceRes_Gender: ASGE_FSDK_GENDERFACEINPUT;
  lFaceRegions: TList<AFR_FSDK_FACEINPUT>;
  lAgeRes: ASAE_FSDK_AGERESULT;
  lGenderRes: ASGE_FSDK_GENDERRESULT;
  lAges: TArray<Integer>;
  lGenders: TArray<Integer>;
  lFaceInfo: TFaceBaseInfo;
  i, iFaces: Integer;
  iWidth, iHeight, iLineBytes: Integer;
  ArrFaceOrient: array of AFT_FSDK_OrientCode;
  ArrFaceRect: array of MRECT;
  R: MRESULT;
begin
  Result := False;

  if AFaceInfos = nil then
    AFaceInfos := TList<TFaceBaseInfo>.Create;

  if FFaceDetectionEngine = nil then
    Exit;

  pImgData := nil;

  if not ReadBmp(ABitmap, pImgData, iWidth, iHeight, iLineBytes) then
    Exit;

  offInput.u32PixelArrayFormat := ASVL_PAF_RGB24_B8G8R8;
  FillChar(offInput.pi32Pitch, SizeOf(offInput.pi32Pitch), 0);
  FillChar(offInput.ppu8Plane, SizeOf(offInput.ppu8Plane), 0);

  offInput.i32Width := iWidth;
  offInput.i32Height := iHeight;

  offInput.ppu8Plane[0] := IntPtr(pImgData);
  offInput.pi32Pitch[0] := iLineBytes;

  lFaceRegions := TList<AFR_FSDK_FACEINPUT>.Create;
  try
    //�������
    R := AFT_FSDK_FaceFeatureDetect(FFaceTrackingEngine, @offInput, pFaceRes);
    if R = MOK then
    begin
      //�ֽ�����λ����Ϣ
      ExtractFaceBoxs(pFaceRes^, lFaceRegions);
      if lFaceRegions.Count > 0 then
      begin
        iFaces := lFaceRegions.Count;
        SetLength(ArrFaceOrient, iFaces);
        SetLength(ArrFaceRect, iFaces);
        for i := 0 to iFaces - 1 do
        begin
          ArrFaceOrient[i] := lFaceRegions.Items[i].lOrient;
          ArrFaceRect[i] := lFaceRegions.Items[i].rcFace;
        end;

        //�������
        if (FFaceAgeEngine <> nil) then
        begin
          with lFaceRes_Age do
          begin
            pFaceRectArray := @ArrFaceRect[0];
            pFaceOrientArray := @ArrFaceOrient[0];
            lFaceNumber := iFaces;
          end;

          if ASAE_FSDK_AgeEstimation_Preview(
            FFaceAgeEngine, //[in] age estimation engine
            @offInput, //[in] the original image information
            //[in] the face rectangles information
            @lFaceRes_Age,
            //[out] the results of age estimation
            lAgeRes
            ) = MOK then
            //�ֽ���������
            ExtractFaceAges(lAgeRes, lAges);

        end;

        //����Ա�
        if (FFaceGenderEngine <> nil) then
        begin
          with lFaceRes_Gender do
          begin
            pFaceRectArray := @ArrFaceRect[0];
            pFaceOrientArray := @ArrFaceOrient[0];
            lFaceNumber := iFaces;
          end;

          if ASGE_FSDK_GenderEstimation_Preview(
            FFaceGenderEngine, //[in] Gender estimation engine
            @offInput, //[in] the original imGender information
            //[in] the face rectangles information
            @lFaceRes_Gender,
            //[out] the results of Gender estimation
            lGenderRes
            ) = MOK then
            //�ֽ������Ա�
            ExtractFaceGenders(lGenderRes, lGenders);

        end;

        for i := 0 to iFaces - 1 do
        begin
          lFaceInfo.Init;
          lFaceInfo.FaceRect := ArrFaceRect[i];
          lFaceInfo.FaceOrient := ArrFaceOrient[i];
          if i < Length(lAges) then
            lFaceInfo.Age := lAges[i];
          if i < Length(lGenders) then
            lFaceInfo.Gender := lGenders[i];
          AFaceInfos.Add(lFaceInfo);
        end;
      end;

    end;
  finally
    FreeAndNil(lFaceRegions);
  end;

  if pImgData <> nil then
    FreeMem(pImgData);

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.UnInitialFaceTrackingEngine
 ����:      �ͷ�������������
 ����:      Bird
 ����:      2017.09.24
 ����:      ��
 ����ֵ:    Integer
 -------------------------------------------------------------------------------}
function TArcFaceSDK.UnInitialFaceTrackingEngine: Integer;
begin
  if FFaceTrackingEngine <> nil then
  begin
    Result := AFT_FSDK_UninitialFaceEngine(FFaceTrackingEngine);
    if Result = MOK then
      FFaceTrackingEngine := nil;
  end
  else
    Result := MOK;

  if FpFaceTrackingBuf <> nil then
  begin
    FreeMem(FpFaceTrackingBuf);
    FpFaceTrackingBuf := nil;
  end;

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.UnInitialFaceRecognitionEngine
 ����:      �ͷ�����ʶ������
 ����:      Bird
 ����:      2017.09.24
 ����:      ��
 ����ֵ:    Integer
 -------------------------------------------------------------------------------}
function TArcFaceSDK.UnInitialFaceRecognitionEngine: Integer;
begin
  if FFaceRecognitionEngine <> nil then
  begin
    Result := AFR_FSDK_UninitialEngine(FFaceRecognitionEngine);
    if Result = MOK then
      FFaceRecognitionEngine := nil;
  end
  else
    Result := MOK;

  if FpFaceRecognitionBuf <> nil then
  begin
    FreeMem(FpFaceRecognitionBuf);
    FpFaceRecognitionBuf := nil;
  end;

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.UnInitialFaceAgeEngine
 ����:      �ͷ�����ʶ������
 ����:      Bird
 ����:      2017.09.24
 ����:      ��
 ����ֵ:    Integer
 -------------------------------------------------------------------------------}
function TArcFaceSDK.UnInitialFaceAgeEngine: Integer;
begin
  if FFaceAgeEngine <> nil then
  begin
    Result := ASAE_FSDK_UninitAgeEngine(FFaceAgeEngine);
    if Result = MOK then
      FFaceAgeEngine := nil;
  end
  else
    Result := MOK;

  if FpFaceAgeBuf <> nil then
  begin
    FreeMem(FpFaceAgeBuf);
    FpFaceAgeBuf := nil;
  end;

end;

{-------------------------------------------------------------------------------
 ������:    TArcFaceSDK.UnInitialFaceGenderEngine
 ����:      �ͷ�����ʶ������
 ����:      Bird
 ����:      2017.09.24
 ����:      ��
 ����ֵ:    Integer
 -------------------------------------------------------------------------------}
function TArcFaceSDK.UnInitialFaceGenderEngine: Integer;
begin
  if FFaceGenderEngine <> nil then
  begin
    Result := ASGE_FSDK_UninitGenderEngine(FFaceGenderEngine);
    if Result = MOK then
      FFaceGenderEngine := nil;
  end
  else
    Result := MOK;

  if FpFaceGenderBuf <> nil then
  begin
    FreeMem(FpFaceGenderBuf);
    FpFaceGenderBuf := nil;
  end;

end;

constructor TFaceModels.Create;
begin
  inherited;
  FModels := TList<AFR_FSDK_FACEMODEL>.Create;
end;

destructor TFaceModels.Destroy;
begin
  Clear;
  FModels.Free;
  inherited;
end;

function TFaceModels.AddModel(AModel: AFR_FSDK_FACEMODEL): Integer;
begin
  Result := FModels.Add(AModel);
end;

procedure TFaceModels.Assign(ASource: TFaceModels);
begin
  Clear;
  AddModels(ASource);
end;

procedure TFaceModels.AddModels(ASource: TFaceModels);
var
  i: Integer;
  lSourceModel, lDestModel: AFR_FSDK_FACEMODEL;
begin
  for i := 0 to ASource.Count - 1 do
  begin
    lSourceModel := ASource.FaceModel[i];

    lDestModel.lFeatureSize := lSourceModel.lFeatureSize;
    GetMem(lDestModel.pbFeature, lDestModel.lFeatureSize);
    CopyMemory(lDestModel.pbFeature, lSourceModel.pbFeature,
      lDestModel.lFeatureSize);

    FModels.Add(lDestModel);
  end;

end;

procedure TFaceModels.Clear;
var
  i: Integer;
begin
  if FModels.Count > 0 then
    for i := FModels.Count - 1 downto 0 do
    begin
      if FModels.Items[i].pbFeature <> nil then
      begin
        FreeMem(FModels.Items[i].pbFeature);
      end;
      FModels.Delete(i);
    end;
end;

procedure TFaceModels.Delete(Index: Integer);
begin
  if (Index >= 0) and (Index < FModels.Count) then
  begin
    if FModels.Items[Index].pbFeature <> nil then
      FreeMem(FModels.Items[Index].pbFeature);
    FModels.Delete(Index);
  end;
end;

function TFaceModels.GetCount: Integer;
begin
  Result := FModels.Count;
end;

function TFaceModels.GetFaceModel(Index: Integer): AFR_FSDK_FACEMODEL;
begin
  Result.lFeatureSize := 0;
  Result.pbFeature := nil;
  if (Index >= 0) and (Index < FModels.Count) then
    Result := FModels.Items[Index];
end;

function TFaceModels.GetItems(Index: Integer): AFR_FSDK_FACEMODEL;
begin
  Result.lFeatureSize := 0;
  Result.pbFeature := nil;
  if (Index >= 0) and (Index < FModels.Count) then
    Result := FModels.Items[Index];
end;

function TuJpegImage.BitmapData: TBitmap;
begin
  Result := Bitmap;
end;

constructor TEdzFaceModels.Create;
begin
  inherited;
  FRyID := '';
  FParams := '';
end;

procedure TEdzFaceModels.Assign(ASource: TFaceModels);
begin
  inherited;
  if ASource is TEdzFaceModels then
  begin
    with TEdzFaceModels(ASource) do
    begin
      Self.FRyID := RyID;
      Self.FParams := Params;
    end;
  end;
end;

procedure TEdzFaceModels.Clear;
var
  i: Integer;
begin
  inherited;
  FRyID := '';
  FParams := '';
end;

procedure TFaceBaseInfo.Init;
begin
  Age := 0;
  Gender := 0;
  FaceOrient := 0;
  with FaceRect do
  begin
    left := 0;
    right := 0;
    top := 0;
    bottom := 0;
  end;

end;

procedure TFaceFullInfo.Init;
begin
  Age := 0;
  Gender := 0;
  FaceOrient := 0;
  with FaceRect do
  begin
    left := 0;
    right := 0;
    top := 0;
    bottom := 0;
  end;

end;

end.
