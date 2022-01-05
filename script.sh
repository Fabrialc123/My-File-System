#!/bin/bash
MPOINT="./mount-point"
#a) Copie dos ficheros de texto que ocupen mas de un bloque(por ejemplo fuseLib.c y
# myFS.h) a nuestro SF y a un directorio temporal, por ejemplo ./temp
#borrar directorio en el caso de que exista
rm -R -f tmp
mkdir tmp

echo "Copiando myFS.h"
cp ./src/myFS.h $MPOINT/
cp ./src/myFS.h ./tmp
read -p "Pulsa enter para continuar..."

echo "Copiando fuseLib.c"
cp ./src/fuseLib.c $MPOINT/
cp ./src/fuseLib.c ./tmp
read -p "Pulsa enter para continuar..."


#b) Audite el disco y haga un diff entre los ficheros originales y los copiados en el SF
#Trunque el primer fichero (man truncate) en copiasTemporales y en nuestro SF de
#manera que ocupe ocupe un bloque de datos menos.
echo "Auditando fuseLib.c y myFS.h"

./my-fsck ./virtual-disk

if diff -q ./tmp/fuseLib.c $MPOINT/fuseLib.c > /dev/null; then 
echo "fuseLib.c son iguales"
else
echo "fuseLib.c no son iguales"
fi

if diff -q ./tmp/myFS.h $MPOINT/myFS.h > /dev/null; then 
echo "myFS.h son iguales"
else
echo "myFS.h no son iguales"
fi
read -p "Pulsa enter para continuar..."

echo "Truncando fuseLib.c - 1"
truncate -o -s -1 ./tmp/fuseLib.c
truncate -o -s -1 $MPOINT/fuseLib.c

read -p "Pulsa enter para continuar..."

#c) Audite el disco y haga un diff entre el fichero original y el truncado.
echo "Auditando fuseLib.c truncado"

./my-fsck ./virtual-disk

if diff -q ./tmp/fuseLib.c $MPOINT/fuseLib.c > /dev/null; then 
echo "fuseLib.c son iguales"
else
echo "fuseLib.c no son iguales"
fi
read -p "Pulsa enter para continuar..."

#d) Copie un tercer fichero de texto a nuestro SF.
echo "Creando fichero de texto 'file.txt'"
echo 'Fichero de Texto' > ./tmp/file.txt
echo 'Fichero de Texto' > $MPOINT/file.txt
read -p "Pulsa enter para continuar..."

#e) Audite el disco y haga un diff entre el fichero original y el copiado en el SF
echo "Auditando file.txt"

if diff -q ./tmp/file.txt $MPOINT/file.txt > /dev/null; then 
echo "file.txt son iguales"
else
echo "file.txt no son iguales"
fi

read -p "Pulsa enter para continuar..."

#f) Trunque el segundo fichero en copiasTemporales y en nuestro SF haciendo que ocupe
#algún bloque de datos más.
echo "Truncando myFS.h + 1"
truncate -o -s +1 ./tmp/myFS.h
truncate -o -s +1 $MPOINT/myFS.h
read -p "Pulsa enter para continuar..."

#g) Audite el disco y haga un diff entre el fichero original y el truncado
echo "Auditando myFS.h truncado"
./my-fsck ./virtual-disk

if diff -q ./tmp/myFS.h $MPOINT/myFS.h > /dev/null; then 
echo "myFS.h son iguales"
else
echo "myFS.h no son iguales"
fi
read -p "Pulsa enter para continuar..."
