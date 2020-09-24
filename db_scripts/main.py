file_path = "EPS.csv"

reader = open( file_path, "r", encoding='utf8' )
linea = reader.readline()

writer = open( "EPS_normalizado.csv", "w", encoding='utf8')

while linea != "":
    split = linea.replace("\n", "").split(";")
    id = split[0]
    eps = split[1].upper().replace("-", "").split(" ")
    #eps = split[1].title().replace( " De ", " de " ).replace( " Del ", " del ").replace( " Y ", " y " )

    for i in range( len(eps) ):
        if "." in eps[i]: eps[i] = eps[i].title()
        elif eps[i] in ["DE", "LA", "EN", "Y" ]: eps[i] = eps[i].lower()
        elif eps[i] in ["EPS", "SAS", "PE", "EAS", "AIG", "ESS", "UT", "RES", "ARS" ]: eps[i] = eps[i].upper()
        elif "(" in eps[i]: eps[i] = "(" + "".join( eps[i][1:] ).capitalize()
        else: eps[i] = eps[i].capitalize()

    eps = " ".join( eps )

    #print( eps )
    writer.writelines( id + "," + eps + "\n" )
    linea = reader.readline()
#df.id = df.id.astype(str)
#df.eps = df.eps.astype(str)