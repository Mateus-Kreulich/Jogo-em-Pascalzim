program JogoRPG;

type
  Personagem = record
    Nome: string;
    Vida: Integer;
    VidaMaxima: Integer;
    Ataque: Integer;
    Defesa: Integer;
    Dinheiro: Integer;
    MultiplicadorDano: Real;
    Nivel: Integer;
    Experiencia: Integer;
    Escudo: Boolean;
  end;

  Inimigo = record
    Nome: string;
    Vida: Integer;
    Ataque: Integer;
    Defesa: Integer;
    Experiencia: Integer;
  end;

  Arma = record
    Nome: string;
    Ataque: Integer;
    Preco: Integer;
  end;

  PocaoCura = record
    Nome: string;
    Cura: Integer;
    Preco: Integer;
  end;

  EscudoItem = record
    Nome: string;
    Defesa: Integer;
    Preco: Integer;
  end;

const
  NumInimigos = 4;
  NomesInimigos: array[1..NumInimigos] of string = ('Goblin', 'Esqueleto', 'Zumbi', 'Ogro');

  NumArmas = 4;
  ArmasDisponiveis: array[1..NumArmas] of Arma = (
  	(Nome: 'Adaga'; Ataque: 10; Preco: 20),
    (Nome: 'Espada'; Ataque: 25; Preco: 50),
    (Nome: 'Machado'; Ataque: 40; Preco: 80),
    (Nome: 'Arco'; Ataque: 50; Preco: 100)
  );

  NumPocoes = 3;
  PocoesDisponiveis: array[1..NumPocoes] of PocaoCura = (
    (Nome: 'Pocao Pequena'; Cura: 20; Preco: 15),
    (Nome: 'Pocao Media'; Cura: 50; Preco: 35),
    (Nome: 'Pocao Grande'; Cura: 100; Preco: 50)
  );

  NumEscudos = 3;
  EscudosDisponiveis: array[1..NumEscudos] of EscudoItem = (
    (Nome: 'Escudo de Madeira'; Defesa: 5; Preco: 20),
    (Nome: 'Escudo de Ferro'; Defesa: 10; Preco: 35),
    (Nome: 'Escudo de Aco'; Defesa: 20; Preco: 50)
  );

var
  Jogador: Personagem;
  InimigoAtual: Inimigo;

procedure InicializarJogador;
begin
  Jogador.Nome := 'Heroi';
  Jogador.Vida := 100;
  Jogador.VidaMaxima := 100;
  Jogador.Ataque := 15;
  Jogador.Defesa := 1;
  Jogador.Dinheiro := 100;
  Jogador.MultiplicadorDano := 0.5;
  Jogador.Nivel := 1;
  Jogador.Experiencia := 0;
end;

procedure InicializarInimigo;
var
  IndiceInimigo: Integer;
begin
  IndiceInimigo := Random(NumInimigos) + 1;
  InimigoAtual.Nome := NomesInimigos[IndiceInimigo];
  InimigoAtual.Vida := Random(100) + 20;
  InimigoAtual.Ataque := Random(10) + 10;
  InimigoAtual.Defesa := Random(5) + 5;
  InimigoAtual.Experiencia := Random(25) + 5;
end;

procedure ExibirEstatisticas;
begin
  WriteLn('Estatisticas do Jogador:');
  WriteLn('Nome: ', Jogador.Nome);
  WriteLn('Nivel: ', Jogador.Nivel);
  WriteLn('Experiencia: ', Jogador.Experiencia);
  WriteLn('Vida: ', Jogador.Vida, '/', Jogador.VidaMaxima);
  WriteLn('Ataque: ', Jogador.Ataque);
  WriteLn('Defesa: ', Jogador.Defesa);
  WriteLn('Dinheiro: ', Jogador.Dinheiro);
  WriteLn;

  WriteLn('Estatisticas do Inimigo:');
  WriteLn('Nome: ', InimigoAtual.Nome);
  WriteLn('Vida: ', InimigoAtual.Vida);
  WriteLn('Ataque: ', InimigoAtual.Ataque);
  WriteLn('Defesa: ', InimigoAtual.Defesa);
  WriteLn;
end;

procedure AtacarInimigo;
var
  Dano: Integer;
begin
  Dano := Round(Jogador.Ataque * Jogador.MultiplicadorDano) - InimigoAtual.Defesa + Random(5) - 2;
  if Dano < 0 then
    Dano := 0;
  InimigoAtual.Vida := InimigoAtual.Vida - Dano;
  WriteLn('Voce ataca o ', InimigoAtual.Nome, ' e causa ', Dano, ' de dano!');
end;

procedure AtaqueInimigo;
var
  Dano: Integer;
begin
  Dano := InimigoAtual.Ataque - Jogador.Defesa + Random(5) - 2;
  if Dano < 0 then
    Dano := 0;
  Jogador.Vida := Jogador.Vida - Dano;
  if Jogador.Vida <= 0 then
  begin
    Jogador.Vida := 0;
    WriteLn('Voce foi derrotado pelo ', InimigoAtual.Nome, '!');
    WriteLn('Fim de Jogo!');
    ReadLn;
    Halt;
  end;
  WriteLn('O ', InimigoAtual.Nome, ' ataca voce e causa ', Dano, ' de dano!');
end;

procedure Combate;
begin
  repeat
    AtacarInimigo;
    if InimigoAtual.Vida <= 0 then
    begin
      WriteLn('Voce derrotou o ', InimigoAtual.Nome, '!');
      Jogador.Experiencia := Jogador.Experiencia + InimigoAtual.Experiencia;
      if Jogador.Experiencia >= 100 then
      begin
        Jogador.Nivel := Jogador.Nivel + 1;
        Jogador.Experiencia := 0;
        // Ajuste dos atributos do jogador com base no novo nível
        Jogador.VidaMaxima := Jogador.VidaMaxima + 10;
        Jogador.Ataque := Jogador.Ataque + 5;
        Jogador.Defesa := Jogador.Defesa + 3;
        WriteLn('Parabens! Voce subiu para o nivel ', Jogador.Nivel, '!');
      end;
      Jogador.Dinheiro := Jogador.Dinheiro + Random(10) + 10;
      Exit;
    end;
    AtaqueInimigo;
    ExibirEstatisticas;
    WriteLn('Pressione Enter para continuar...');
    ReadLn;
  until (Jogador.Vida <= 0) or (InimigoAtual.Vida <= 0);
end;

procedure MostrarLoja;
var
  Escolha: Integer;
begin
  repeat
    WriteLn('Bem-vindo a loja!');
    WriteLn('Dinheiro disponivel: ', Jogador.Dinheiro);
    WriteLn('Armas disponiveis:');
    for Escolha := 1 to NumArmas do
      WriteLn(Escolha, '. ', ArmasDisponiveis[Escolha].Nome, ' - Ataque: ', ArmasDisponiveis[Escolha].Ataque, ' Preco: ', ArmasDisponiveis[Escolha].Preco);
    WriteLn('Pocoes de Cura:');
    for Escolha := 1 to NumPocoes do
      WriteLn(Escolha + NumArmas, '. ', PocoesDisponiveis[Escolha].Nome, ' - Cura: ', PocoesDisponiveis[Escolha].Cura, ' Preco: ', PocoesDisponiveis[Escolha].Preco);
    WriteLn('Escudos:');
    for Escolha := 1 to NumEscudos do
      WriteLn(Escolha + NumArmas + NumPocoes, '. ', EscudosDisponiveis[Escolha].Nome, ' - Defesa: ', EscudosDisponiveis[Escolha].Defesa, ' Preco: ', EscudosDisponiveis[Escolha].Preco);
    WriteLn('0. Sair da loja');

    Write('Escolha um item para comprar: ');
    ReadLn(Escolha);

    if (Escolha > 0) and (Escolha <= NumArmas) then
    begin
      if Jogador.Dinheiro >= ArmasDisponiveis[Escolha].Preco then
      begin
        WriteLn('Voce comprou uma ', ArmasDisponiveis[Escolha].Nome, '!');
        Jogador.Ataque := Jogador.Ataque + ArmasDisponiveis[Escolha].Ataque;
        Jogador.Dinheiro := Jogador.Dinheiro - ArmasDisponiveis[Escolha].Preco;
        Exit;
      end
      else
        WriteLn('Voce nao tem dinheiro suficiente para comprar esta arma!');
    end
    else if (Escolha > NumArmas) and (Escolha <= NumArmas + NumPocoes) then
    begin
      if Jogador.Dinheiro >= PocoesDisponiveis[Escolha - NumArmas].Preco then
      begin
        Jogador.Vida := Jogador.Vida + PocoesDisponiveis[Escolha - NumArmas].Cura;
        if Jogador.Vida > Jogador.VidaMaxima then
          Jogador.Vida := Jogador.VidaMaxima;
        WriteLn('Voce bebeu uma ', PocoesDisponiveis[Escolha - NumArmas].Nome, ' e recuperou ', PocoesDisponiveis[Escolha - NumArmas].Cura, ' de vida!');
        Jogador.Dinheiro := Jogador.Dinheiro - PocoesDisponiveis[Escolha - NumArmas].Preco;
        Exit;
      end
      else
        WriteLn('Voce nao tem dinheiro suficiente para comprar esta pocao!');
    end
    else if (Escolha > NumArmas + NumPocoes) and (Escolha <= NumArmas + NumPocoes + NumEscudos) then
    begin
      if Jogador.Dinheiro >= EscudosDisponiveis[Escolha - NumArmas - NumPocoes].Preco then
      begin
        Jogador.Defesa := Jogador.Defesa + EscudosDisponiveis[Escolha - NumArmas - NumPocoes].Defesa;
        Jogador.Escudo := True;
        WriteLn('Voce comprou um ', EscudosDisponiveis[Escolha - NumArmas - NumPocoes].Nome, ' e aumentou sua defesa em ', EscudosDisponiveis[Escolha - NumArmas - NumPocoes].Defesa, '!');
        Jogador.Dinheiro := Jogador.Dinheiro - EscudosDisponiveis[Escolha - NumArmas - NumPocoes].Preco;
        Exit;
      end
      else
        WriteLn('Voce nao tem dinheiro suficiente para comprar este escudo!');
    end
    else if Escolha <> 0 then
      WriteLn('Escolha invalida. Por favor, tente novamente.');
  until Escolha = 0;
end;

procedure JogoPrincipal;
var
  Escolha: Char;
begin
  Randomize;
  InicializarJogador;

  repeat
    InicializarInimigo;
    ExibirEstatisticas;
    WriteLn('O que voce gostaria de fazer?');
    WriteLn('(A)tacar');
    WriteLn('(L)oja');
    WriteLn('(S)air');
    ReadLn(Escolha);
    case UpCase(Escolha) of
      'A': Combate;
      'L': MostrarLoja;
      'S': WriteLn('Ate logo!');
      else
        WriteLn('Escolha invalida. Por favor, tente novamente.');
    end;
  until UpCase(Escolha) = 'S';

  if Jogador.Vida <= 0 then
  begin
    WriteLn('Fim de Jogo!');
    ReadLn;
  end;
end;

begin
  JogoPrincipal;
end.
