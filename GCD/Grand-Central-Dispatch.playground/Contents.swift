import UIKit

// GCD o Grand CEntral Dispatch gestiona básicamente la ejecución de hilos y subprocesos que corren de manera simultánea.

func sumar() -> Int {
    return 3 + 5
}

func restar() -> Int {
    return 10 - 5
}

func multiplicar() -> Int {
    return 7 * 5
}

func dividir() -> Int {
    return 30 / 5
}


func modulo() -> Int {
    return 30 % 5
}


// Main Dispatch Queue
// Ejecuta todas las tareas en el hilo principal.
// Dado que todo lo que modifica la interfaz de usuario debe ejecutarse en el hilo principal, es común usarlo para actualizar la interfaz de usuario después que finaliza el trabajo de una tarea o proceso en una cola simultánea o en "background"
DispatchQueue.main.async {
    print("Suma.: \(sumar())")
    print("Resta.: \(restar())")
    print("Modulo.: \(modulo())")
}


// Concurrent Queues (Global Queues)
// Una tarea consta de uno o varios subprocesos. Las colas o "queues" concurrentes ejecutan una o más tareas al mismo tiempo. Sin embargo, como su nombre lo indica, todavía mantiene su orden de ejecución FIFO. Las tareas que se están ejecutando actualmente se ejecutan en diferentes subprocesos que son administrados por la cola de despacho (Dispatch Queue).
DispatchQueue.global().async {
    print("Suma.: \(sumar())")
}


// Hay cuatro colas de este tipo que tienen diferentes prioridades: alta, predeterminada, baja y en segundo plano. La cola de prioridad en segundo plano tiene la prioridad más baja. Cuando enviamos tareas a las colas simultáneas globales, especificamos una propiedad de clase de Calidad de servicio (QoS) que determina las prioridades.
// qos: Quality of Service
// Los valores posibles de "qos" son:

// userInteractive: se utiliza para actualizaciones de UI, mpor ello debería ejecutarse en el hilo principal.

// userInitiated: se ejecuta con alta prioridad (high priority)

// utility: se ejecuta con baja prioridad (low priority)

// background: tiene la mas baja prioridad (lowest priority)

DispatchQueue.global(qos: .userInitiated).async {
    print("Resta.: \(restar())")
}

DispatchQueue.global(qos: .userInteractive).async {
    print("Dividir.: \(dividir())")
}


// Synchronous vs. Asynchronous

// Sincrónico
// Una función síncrona pasa a la siguiente función después de que se completa la tarea. Programamos un bloque de trabajo sincrónicamente llamando a:  DispatchQueue.sync(execute:)

DispatchQueue.global().sync {
    print("sumar.: \(sumar())")
    print("restar.: \(restar())")
    print("multiplicar.: \(multiplicar())")
    print("dividir.: \(dividir())")
    print("modulo.: \(modulo())")
}


// Asincrónico
// Una función asincrónica ordena que la tarea se inicie y regresa inmediatamente. Sin embargo, no espera a que se complete la tarea. Por lo tanto, no bloquea la ejecución en el hilo actual para pasar a la siguiente función. Programamos un bloque de trabajo de forma asincrónica llamando a: DispatchQueue.async(execute:)

DispatchQueue.global().async {
    print("sumar.: \(sumar())")
    print("restar.: \(restar())")
    print("multiplicar.: \(multiplicar())")
    print("dividir.: \(dividir())")
    print("modulo.: \(modulo())")
}



// Dispatch Groups
// gestiona grupos de despacho. Usando grupos de despacho (Dispatch Groups) , podemos crear grupos de múltiples tareas y esperar a que se completen o recibir una notificación una vez que se completen. El siguiente código es un ejemplo de cómo recibir una notificación cuando se completan todas las colas del grupo.

// Se crea el grupo
let dispatchGroup = DispatchGroup()
let queue1 = DispatchQueue(label: "suma")
let queue2 = DispatchQueue(label: "resta")
let queue3 = DispatchQueue(label: "multiplicacion")
let queue4 = DispatchQueue(label: "division")
let queue5 = DispatchQueue(label: "modulo")

// ponemos toas las queues en el dispatchGroup
queue1.async(group: dispatchGroup) {
  print("sumar.: \(sumar())")
}
queue2.async(group: dispatchGroup) {
    print("restar.: \(restar())")
}
queue3.async(group: dispatchGroup) {
    print("multiplicar.: \(multiplicar())")
}
queue4.async(group: dispatchGroup) {
    print("dividir.: \(dividir())")
}
queue5.async(group: dispatchGroup) {
    print("modulo.: \(modulo())")
}

// Cuando se completan todas las tareas volvemos al main thread
dispatchGroup.notify(queue: DispatchQueue.main) {
  print("Todas las tareas asincrónicas han finalizado.")
}

