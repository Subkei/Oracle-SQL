-- Sebastián Acevedo G. Talento Digital 2020, Viña del Mar CFT Valparaiso
-- Pregunta 1: Conocer el número de evaluaciones por curso.
select	c.curso_nombre as "Nombre de Curso",
e.ev_alumno_puntaje as "Evaluaciones por Curso",
replace (a.alumno_ev_verdadero, 1, 'SI') "Curso con Evaluación"
from evaluacion e, alumno a, curso c
where a.alumno_codigo=e.alumno_alumno_codigo
and a.curso_curso_codigo=c.curso_codigo
and a.alumno_ev_verdadero=1;

-- Pregunta 2: Conocer los cursos sin evaluaciones.
select distinct	c.curso_nombre as "Nombre de Curso",
e.ev_alumno_puntaje as "Evaluaciones por Curso",
replace (a.alumno_ev_verdadero, 0, 'NO')  "Curso con Evaluación"
from evaluacion e, alumno a, curso c, test t
where a.alumno_codigo=e.alumno_alumno_codigo
and a.curso_curso_codigo=c.curso_codigo
and a.alumno_ev_verdadero=0
and e.ev_alumno_puntaje=0;

-- Pregunta 3: Determinar las evaluaciones con deficiencia. Una evaluación es deficiente:
-- a. Si no tiene preguntas.
-- b. Si hay preguntas con 2 ó menos alternativas
-- c. Si todas las alternativas son correctas o si todas las alternativas son incorrectas.
select t.test_codigo as "Codigo de Test",
t.test_nombre as "Nombre del Test",
p.preg_enunciado as "Enunciado de la Pregunta",
al.alt_descripcion as "Alternativas",
replace(replace(al.alt_valor_logico,0,'NO'),1,'SI') as "¿Es correcta?"
from preg_respuesta pr, alternativa al, test t, test_pregunta tp, pregunta p
where tp.pregunta_preg_codigo=p.preg_codigo
and t.test_codigo=tp.test_test_codigo
and pr.alternativa_alt_codigo=al.alt_codigo
and pr.pregunta_preg_codigo=p.preg_codigo;
 
-- Pregunta 4: Determinar cuántos alumnos hay en cada curso.
select c.curso_codigo as "Codigo de Curso",
c.curso_nombre as "Nombre del Curso",
count (c.curso_codigo) as "Alumnos por Curso"
from alumno a, curso c
where c.curso_codigo=a.curso_curso_codigo
group by c.curso_codigo, c.curso_nombre
order by c.curso_codigo;

-- Pregunta 5: Obtener el puntaje no normalizado de cada evaluación. El puntaje no normalizado ha sido definido (requerimiento) como: P = buenas – malas/4.
-- Si un alumno no contesta en una pregunta exactamente lo mismo que se ha definido como correcto, la pregunta cuenta como mala a menos que el alumno haya omitido.
select a.alumno_rut as "RUT",
a.alumno_nombre as "Nombre",
a.alumno_apellidos as "Apellidos",
t.test_nombre as "Nombre del Test",
e.ev_alumno_puntaje || '%' as "Puntaje Obtenido"
from alumno a, test t, evaluacion e
where t.test_codigo=e.test_test_codigo
and a.alumno_codigo=e.alumno_alumno_codigo
order by a.alumno_nombre, a.alumno_apellidos;

-- Pregunta 6: Obtener el puntaje normalizado, o sea, de 1,0 a 7,0.
select a.alumno_rut as "RUT",
a.alumno_nombre as "Nombre",
a.alumno_apellidos as "Apellidos",
c.curso_nombre as "Nombre del Curso",
e.ev_alumno_puntaje_n as "Puntaje Normalizado",
e.test_test_codigo as "Codigo Test",
t.test_nombre as "Nombre del Test"
from test t, curso c, evaluacion e, alumno a
where a.curso_curso_codigo=c.curso_codigo
and	e.alumno_alumno_codigo=a.alumno_codigo
and t.test_codigo=e.test_test_codigo
order by a.alumno_nombre ASC, a.alumno_apellidos ASC, e.test_test_codigo ASC;

-- Pregunta 7: Nombre de estudiantes de un curso determinado que aprueban una evaluación determinada (donde la nota de aprobación mínima es un 4,0).
select a.alumno_rut as "RUT",
a.alumno_nombre as "Nombre",
a.alumno_apellidos as "Apellidos",
c.curso_nombre as "Nombre del Curso",
e.ev_alumno_puntaje || '%' as "Puntaje Obtenido",
e.ev_alumno_puntaje_n as "Puntaje Normalizado",
e.test_test_codigo as "Codigo Test",
t.test_nombre as "Nombre del Test"
from test t, curso c, evaluacion e, alumno a
where a.curso_curso_codigo=c.curso_codigo
and	e.alumno_alumno_codigo=a.alumno_codigo
and t.test_codigo=e.test_test_codigo
and e.ev_alumno_puntaje>=60
order by a.alumno_nombre ASC, a.alumno_apellidos ASC, e.test_test_codigo ASC;

-- Pregunta 8: Nota promedio de los estudiantes de un curso determinado, para una evaluación determinada.
select a.alumno_rut as "RUT",
a.alumno_nombre as "Nombre",
a.alumno_apellidos as "Apellidos",
c.curso_nombre as "Nombre del Curso",
avg(e.ev_alumno_puntaje) || '%' as "Puntaje Obtenido",
avg(e.ev_alumno_puntaje_n) as "Puntaje Normalizado"
from curso c, evaluacion e, alumno a
where a.curso_curso_codigo=c.curso_codigo
and	e.alumno_alumno_codigo=a.alumno_codigo
group by a.alumno_rut, a.alumno_nombre, a.alumno_apellidos, c.curso_nombre, e.ev_alumno_puntaje,e.ev_alumno_puntaje_n;