//Monitorizarea Proceselor Girnet Andrei 311CB

*Logica Scriptului

	Flagurile au fost memorate in variabila flags, pentru 
	a fi in stare sa le modific dupa dorinta

	Am observat ca , cifre > 0, literele nu

	Contorizarea timpului are loc cu ajutorul unui sleep, cit 
	timp el exista inseamna ca scriptul trebuie sa ruleze

	Compar cu ultimele 5 pid-uri, pentru o rapiditate mai mare
	
	Monitorizarea unui proces anume: cu ajutorul grep
	
	Compar daca ultimul pid afisat e mai mare decit pidul actual
	si daca comanda e cea data
	
*Precizia de monitorizare

	Procesele care au un timp de viata de la 0.5s ± 0.1s si mai mult 
	sunt inregistrate si afisate integral
	
	Procesele care au un timp de viata intre 0.2s-0.5s ± 0.01s pot fi capturate partial,
	adica lipsesc unele iesiri cum ar user name etc.
	
	Procesele cu o durata de viata mai mica decit 0.2s ± 0.01s nu sunt inregistrate
	in nici un fel
	
*Exemple utilizare
	
	{Afiseaza toate procesele noi care apar pina utilizatorul nu va da ctr+c}
	bash pspy.sh
	
	{Afiseaza toate procesele noi create timp de 10 secunde}
	bash pspy.sh 10
	
	{Se afiseaza doar comenzile care au bash, timp de 10 secunde}
	bash pspy.sh 10 bash
	
	{Afiseaza doar comenzile care au bash, pina utilizatorul nu va da ctr+c}
	bash pspy.sh bash
	
	{Afiseaza procesele cu o piesa buna pe fundal [piesa e in rusa]}
	bash pspy.sh play
	bash pspy.sh 10 play
	bash pspy.sh 10 bash play
	bash pspy.sh play 10
	etc.
