unit GameLore;

interface

uses FGL, Classes, SysUtils,
	CastleDownload,
	GameTypes, Serialization;

type
	TLoreItem = class (TSerialized)
	private
		FLoreId: TLoreId;
		FLoreName: String;
		FLoreDescription: String;

	published
		property LoreId: TLoreId read FLoreId write FLoreId;
		property LoreName: String read FLoreName write FLoreName;
		property LoreDescription: String read FLoreDescription write FLoreDescription;

	end;

	TLoreItems = specialize TFPGObjectList<TLoreItem>;

	TLoreStore = class
	private
		FItems: TLoreItems;

	public
		constructor Create();
		destructor Destroy(); override;

		procedure Initialize();
		function GetById(const vId: TLoreId): TLoreItem;

	published

		property Items: TLoreItems read FItems write FItems;
	end;

var
	LoreCollection: TLoreStore;

implementation

constructor TLoreStore.Create();
begin
	FItems := TLoreItems.Create;
end;

destructor TLoreStore.Destroy();
begin
	FItems.Free;
	inherited;
end;

procedure TLoreStore.Initialize();
var
	vStreamer: TGameStreamer;
	vLines: TStringList;
	vStream: TStream;
begin
	vStreamer := TGameStreamer.Create;
	vLines := TStringList.Create;

	vStream := Download('castle-data:/lore.json');
	vLines.LoadFromStream(vStream);
	vStreamer.DeStreamer.JSONToObject(vLines.Text, self);

	vStreamer.Free;
	vLines.Free;
	vStream.Free;
end;

function TLoreStore.GetById(const vId: TLoreId): TLoreItem;
var
	vItem: TLoreItem;
begin
	result := nil;
	for vItem in FItems do begin
		if vItem.LoreId = vId then
			result := vItem;
	end;

	if result = nil then
		raise Exception.Create('Lore item with id ' + vId + ' does not exist');
end;

{ implementation end }

initialization
	ListSerializationMap.Add(TSerializedList.Create(TLoreItems, TLoreItem));
	LoreCollection := TLoreStore.Create;

finalization
	LoreCollection.Free;

end.

