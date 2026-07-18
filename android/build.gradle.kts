allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// В этом тулчейне модули с Java 17/11 оставляют bootclasspath-провайдер пустым
// (Cannot query the value of this provider на compileDebugJavaWithJavac).
// Принудительно переводим все подпроекты-плагины на Java 8.
subprojects {
    if (project.name != "app") {
        afterEvaluate {
            // Некоторые плагины (напр. file_picker) не имеют доступного
            // compileOptions на этом этапе — оборачиваем, чтобы NPE не рушил
            // конфигурацию (они и так собираются на Java 8 по умолчанию).
            runCatching {
                extensions.findByName("android")?.withGroovyBuilder {
                    getProperty("compileOptions").withGroovyBuilder {
                        setProperty("sourceCompatibility", JavaVersion.VERSION_1_8)
                        setProperty("targetCompatibility", JavaVersion.VERSION_1_8)
                    }
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
