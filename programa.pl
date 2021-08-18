jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).

% 1)
% a)
tieneItem(Jugador,Item):-
    jugador(Jugador,Items,_),
    member(Item, Items).

% b)
sePreocupaPorSuSalud(Jugador):-
    jugador(Jugador,_,_),
    tieneMasDeUnTipoDeComestible(Jugador).

tieneItemComestible(Jugador,Item):-
    tieneItem(Jugador,Item),
    comestible(Item).

tieneMasDeUnTipoDeComestible(Jugador):-
    tieneItemComestible(Jugador,Item),
    tieneItemComestible(Jugador,OtroItem),
    Item \= OtroItem.

% c)
cantidadDeItem(Jugador,Item,Cantidad):-
    item(Item),
    jugador(Jugador,_,_),
    findall(Item,tieneItem(Jugador,Item),CantidadItems),
    length(CantidadItems, Cantidad).

item(Item):- tieneItem(_,Item).

% d)
tieneMasDe(Jugador,Item):-
    cantidadDeItem(Jugador,Item,Cantidad),
    forall(cantidadDeItem(_,Item,OtraCantidad),
        Cantidad >= OtraCantidad).

% 2)
% a)
hayMonstruos(Lugar):-
    lugar(Lugar,_,NivelOscuridad),
    NivelOscuridad > 6.

%b)
correPeligro(Jugador):-
    seEncuentraEn(Jugador,Lugar),
    hayMonstruos(Lugar).

correPeligro(Jugador):-
    hambriento(Jugador),
    not(tieneItemComestible(Jugador,_)).

seEncuentraEn(Jugador,Lugar):-
    lugar(Lugar,Jugadores,_),
    member(Jugador, Jugadores).

hambriento(Jugador):-
    jugador(Jugador,_,NivelHambre),
    NivelHambre < 4.

% c)
nivelPeligrosidad(Lugar,Nivel):-
    lugar(Lugar,_,Oscuridad),
    cuantosJugadoresEn(Lugar,0),
    Nivel is Oscuridad*10.

nivelPeligrosidad(Lugar,100):-
    esLugar(Lugar),
    hayMonstruos(Lugar).

nivelPeligrosidad(Lugar,Nivel):-
    esLugar(Lugar),
    not(hayMonstruos(Lugar)),
    cuantosJugadoresEn(Lugar,CantidadJugadores),
    CantidadJugadores > 0,
    cuantosHambrientosEn(Lugar,CantidadHambrientos),
    Nivel is (CantidadHambrientos*100/CantidadJugadores).

esLugar(Lugar):- lugar(Lugar,_,_).
    
cuantosJugadoresEn(Lugar,Cantidad):-
    findall(Jugador,seEncuentraEn(Jugador,Lugar),Jugadores),
    list_to_set(Jugadores,JugadoresFilt),
    length(JugadoresFilt, Cantidad).

cuantosHambrientosEn(Lugar,Cantidad):-
    findall(Jugador,hambrientoEnLugar(Lugar,Jugador),Jugadores),
    list_to_set(Jugadores,JugadoresFilt),
    length(JugadoresFilt, Cantidad).
    
hambrientoEnLugar(Lugar,Jugador):-
    hambriento(Jugador),
    seEncuentraEn(Jugador,Lugar).

% 3)
item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).

puedeConstruir(Jugador,Item):-
    itemNecesario(itemSimple(ItemNecesario,Cantidad),Item),
    cantidadDeItem(Jugador,ItemNecesario,Cantidad).

puedeConstruir(Jugador,Item):-
    itemNecesario(itemCompuesto(ItemNecesario),Item),
    puedeConstruir(Jugador,ItemNecesario).
    
itemNecesario(ItemNecesario,Item):-
    item(Item,Items),
    member(ItemNecesario, Items).
    

    




    





