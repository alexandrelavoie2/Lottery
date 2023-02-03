% Alexandre Lavoie
% Lotterie 6/49, Evaluation Sommative 2
% Version 1.0
% 23 sept 2021

% Variables

var x, y, b : int

var Reserve : int := 100
var Nombre_deja_choisi : boolean
var Reponse : int
var Mise : int := 0
var gains : int := 0
var points : int := 0
var match : array 1 .. 6 of int

var Chiffre : array 1 .. 6 of int

var Chiffre_rand : array 1 .. 6 of int

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 Check_Nombre_deja_choisi

 Cherche si le nombre est deja choisi dans un array

 Parametres :
 numeros_piges (array de int) Array qui contient les numeros piges
 nombre_numeros (int) Le nombre de numeros piges

 Return :
 true si le numero est deja choisi
 false si le numero est pas deja choisi
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Check_Nombre_deja_choisi (numeros_piges : array 1 .. 6 of int, nombre_numeros : int) : boolean
	for h : 1 .. nombre_numeros - 1
		if numeros_piges (nombre_numeros) = numeros_piges (h) then
			result true
		end if
	end for
	result false
end Check_Nombre_deja_choisi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 Bubble_Sort

 fonction pour organiser les nombres choisis de methodes croissant.

 Parametres :
 numeros_piges (array de int) Array qui contient les numeros piges
 nombre_numeros (int) Le nombre de numeros piges

 Return :
 Array qui est mis en ordre croissant

 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Bubble_Sort (numeros_piges : array 1 .. 6 of int, nombre_numeros : int) : array 1 .. 6 of int
	var Array_croissant : array 1 .. 6 of int
	Array_croissant := numeros_piges
	var Temp_A, Temp_B : int
	for i : 1 .. nombre_numeros-1
		for j : 1 .. nombre_numeros-1
			if Array_croissant (j) > Array_croissant (j + 1) then
				%Swap values
				Temp_A := Array_croissant (j)
				Temp_B := Array_croissant (j + 1)
				Array_croissant (j + 1) := Temp_A
				Array_croissant (j) := Temp_B
				end if
		end for
	end for
	result Array_croissant
end Bubble_Sort


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 boules

 procedure pour dessiner des boules

 Parametres :
 x, y (int) coordonnees
 Boules_num (int) nombre de boules a dessiner
 Array (array de int) contient les numeros de boules

 Return :
 Aucun
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure boules (x, y, Boules_num : int, Array : array 1..6 of int)
	var affiche : string
	var x2, y2 : int
	x2 := x
	y2 := y
	for i: 1..Boules_num
		drawfilloval (x2, y2, 30, 30, 54)
		affiche := intstr (Array(i))
		Draw.Text (affiche, x2, y2, defFontID, black)
		x2+= 60
		Music.PlayFile("ding.wav")
		delay(50)
	end for

end boules


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 Demander_Nombres

 procedure pour demander 6 nombres

 Parametres :
 Aucun

 Return :
 Aucun
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

procedure Demander_Nombres
	var num_pige : int := 0
	put "Vous devez choisir 6 nombres entre 1 et 49:"
	put " "
	for d : 1 .. 6
		num_pige += 1
		loop
			put "Quel est votre chiffre ", d, "?"
			get Chiffre (d)
			if Chiffre (d) <= 0 or Chiffre (d) > 49 then
				put "Essaye encore. Il faut entrer un nombre entre 1 et 49."
			end if

			Nombre_deja_choisi := Check_Nombre_deja_choisi (Chiffre, num_pige)
			if Nombre_deja_choisi = true then
				put "Le nombre ", Chiffre (num_pige), " est deja choisi."
			end if
			exit when Nombre_deja_choisi = false and Chiffre (d) > 0 and Chiffre (d) <= 49
		end loop
	end for
	Chiffre := Bubble_Sort (Chiffre, num_pige)

end Demander_Nombres


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 Generer_Nombres

 procedure pour generer 6 nombres de l'ordinateur

 Parametres :
 Aucun

 Return :
 Aucun
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure Generer_Nombres
	var num_genere : int := 0
	for i : 1 .. 6
		num_genere += 1
		loop
			randint (Chiffre_rand (i), 1, 49)
			Nombre_deja_choisi := Check_Nombre_deja_choisi (Chiffre_rand, num_genere)
			exit when Nombre_deja_choisi = false
		end loop
	end for
	Chiffre_rand := Bubble_Sort (Chiffre_rand, num_genere)

end Generer_Nombres


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 Determiner_points

 procedure pour calculer combien de nombres genere et choisi sont les memes.

 Parametres :
 Aucun

 Return :
 Aucun
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure Determiner_points
	points := 0
	for j : 1 .. 6
		for p : 1 .. 6
			if Chiffre (j) = Chiffre_rand (p) then
				points += 1
				match (points) := Chiffre (j)
			end if
		end for
	end for
end Determiner_points


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 Determiner_argent

 procedure pour determiner combien d'argent gagne.

 Parametres :
 Aucun

 Return :
 Aucun
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure Determiner_argent
	if points <= 2 then
		put "Vous ne gagnez RIEN (0$)."
		Music.PlayFile("oh-no.wav")
		Reserve := Reserve - 3
		Reserve += 0
	elsif points = 3 then
		put "Vous gagnez 10$."
		Music.PlayFile("yes.wav")
		gains := gains + 10
		Reserve := Reserve - 3
		Reserve += 10
	elsif points = 4 then
		put "Vous gagnez 100$."
		Music.PlayFile("yes.wav")
		gains := gains + 100
		Reserve := Reserve - 3
		Reserve += 100
	elsif points = 5 then
		put "Vous gagnez 10,000$ !!!"
		Music.PlayFile("yes.wav")
		gains := gains + 10000
		Reserve := Reserve - 3
		Reserve += 10000
	elsif points = 6 then
		put "Vous gagnez 10,000,000$ !!!"
		put "Jackpot!!"
		Music.PlayFile("yes.wav")
		gains := gains + 10000000
		Reserve := Reserve - 3
		Reserve += 10000000
	end if
end Determiner_argent


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
 dessiner

 procedure pour dessiner les choix avec boutons.

 Parametres :
 Aucun

 Return :
 Aucun
 */
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure dessiner
	drawfillbox (250, 20, 325, 100, green)
	drawfillbox (450, 20, 375, 100, yellow)
	drawfillbox (600, 20, 525, 100, 40)
	Draw.Text ("Rejouer?", 380, 120, defFontID, black)

	Draw.Text ("Oui Avec", 380, 80, defFontID, black)
	Draw.Text ("Nouveaux", 380, 60, defFontID, black)
	Draw.Text ("Numeros", 380, 40, defFontID, black)

	Draw.Text ("Oui Avec", 260, 80, defFontID, black)
	Draw.Text ("Memes", 260, 60, defFontID, black)
	Draw.Text ("Numeros", 260, 40, defFontID, black)

	Draw.Text ("Non", 550, 65, defFontID, black)

end dessiner



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Debut du programme
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Programme qui fait tout (utilise toutes les procedures)

View.Set ("graphics:1024;768")

% Entrer dans la lotterie (pour la premiere fois)
for Space_548759: 1..45
	put " "
end for

put "Bienvenue a la loterie 6/49! Commencez par entrer vos numeros entre 1 et 49."
put "Vous commencez avec ", Reserve, "$ dans votre compte banque."
var demander_nouveaux_nombres : boolean
demander_nouveaux_nombres := true

loop
	if demander_nouveaux_nombres = true then
		Demander_Nombres
		demander_nouveaux_nombres := false
	end if

	% Entrer dans la lotterie (pour la premiere fois)
	Mise += 3
	put "Voici vos numeros:"
	
	for Space_2: 1..7
		put " "
	end for
	boules (60,75,6,Chiffre)

	Generer_Nombres
	put "Les numeros du tirage sont........"
	delay (2000)
	for Space_3: 1..7
		put " "
	end for
	boules (60,75,6,Chiffre_rand)
	delay (1000)

	Determiner_points
	put "Vos numeros gagnants:"
	for Space_4: 1..7
		put " "
	end for
		
	boules (60,75,points,match)

	% Resultat
	put "Vous avez eu ", points, " numeros gagnants durant ce tirage."
	Determiner_argent
	put "Vous avez perdu mise de ", Mise, "$, et vous avez gagne ", gains, "$."
	put "Vous avez ", Reserve, "$ dans votre compte banque."
	delay (2500)
	put " "

	% Reessayer la loterie ?
	put "Cliquez un bouton pour continuer."
	put "Voulez-vous reessayer la lotterie pour 3$? Voici vos options:"
	for space : 1 .. 8
		put " "
	end for

	% Bouton pour determiner si le user va reessayer avec les memes nombres,
	% reessayer avec de nouveaux nombres ou arreter de gager et quitter le loop.
	dessiner
	loop
		delay (100)
		mousewhere (x, y, b)
		if x >= 250 and x <= 325 and y >= 20 and y <= 100 and b = 1 then
			demander_nouveaux_nombres := false
		elsif x >= 375 and x <= 450 and y >= 20 and y <= 100 and b = 1 then
			demander_nouveaux_nombres := true
		elsif x >= 525 and x <= 600 and y >= 20 and y <= 100 and b = 1 then
			put " "
		end if
		exit when x >= 250 and x <= 325 and y >= 20 and y <= 100 and b = 1
		exit when x >= 375 and x <= 450 and y >= 20 and y <= 100 and b = 1

		exit when x >= 525 and x <= 600 and y >= 20 and y <= 100 and b = 1
	end loop
	exit when x >= 525 and x <= 600 and y >= 20 and y <= 100 and b = 1

	if Reserve <= 2 then
		put "Vous n'avez plus assez d'argent pour participer a la loterie."
	end if
	exit when Reserve <= 2
end loop

% Resultat final
put " "
put " "
put " "
put " "
put "Vous avez perdu une mise totale de ", Mise, "$, et vous "
put "avez gagne ", gains, "$."
put " "
put "Vous avez maintenant ", Reserve, "$."
put " "
put "Bye !"





