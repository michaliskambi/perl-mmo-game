unit GameModels.Move;

interface

uses SysUtils,
	GameModels, GameTypes;

type
	TMsgMove = class(TPlaintextModel)
	public
		class function MessageType(): String; override;

		procedure SetValue(const vX, vY: Single);

	end;

	TMsgFeedActorMovement = class(TModelBase)
	private
		FId: TUlid;
		FPosX: Single;
		FPosY: Single;
		FSpeed: Single;
		FToX: Single;
		FToY: Single;

	public
		class function MessageType(): String; override;

	published
		property id: TUlid read FId write FId;
		property x: Single read FPosX write FPosX;
		property y: Single read FPosY write FPosY;
		property speed: Single read FSpeed write FSpeed;
		property to_x: Single read FToX write FToX;
		property to_y: Single read FToY write FToY;
	end;

implementation

class function TMsgMove.MessageType(): String;
begin
	result := 'move';
end;

procedure TMsgMove.SetValue(const vX, vY: Single);
begin
	// TODO: hardcode
	self.Value := FloatToStr(vX) + '~' + FloatToStr(vY);
end;

class function TMsgFeedActorMovement.MessageType(): String;
begin
	result := 'actor_movement';
end;

{ implementation end }

end.
