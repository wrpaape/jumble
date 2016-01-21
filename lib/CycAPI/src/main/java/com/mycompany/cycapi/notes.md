cd /Users/Reid/my_projects/jumble/lib/CycAPI; JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home "/Applications/NetBeans/NetBeans 8.1.app/Contents/Resources/NetBeans/java/maven/bin/mvn" "-Dexec.args=-Dcyc.session.server=localhost:3600 -classpath %classpath com.mycompany.cycapi.CycAPI" -Dexec.executable=/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home/bin/java -Dcyc.session.server=localhost:3600 org.codehaus.mojo:exec-maven-plugin:1.2.1:exec

--- exec-maven-plugin:1.2.1:exec (default-cli) @ CycAPI ---
log4j:WARN No appenders could be found for logger (com.cyc.session.internal.SessionManagerImpl).
log4j:WARN Please initialize the log4j system properly.
log4j:WARN See http://logging.apache.org/log4j/1.2/faq.html#noconfig for more info.
Running walkthrough...

Current Cyc server: localhost:3600
Cyc server release type: RESEARCHCYC
Cyc server revision number:10.163104

Jack Nicholson as an individual: JackNicholson
Jack Nicholson as a term: JackNicholson
Is Jack Nicholson a collection? false
Are the KbTerm and KbIndividual for #$JackNicholson the exact same object? true
Does Cyc already know that _King of Marvin Gardens_ is an individual? true
Does _King of Marvin Gardens_ exist in Cyc's KB at all? true
TheKingOfMarvinGardens-TheMovie: deleted!

We've created _King of Marvin Gardens_: TheKingOfMarvinGardens-TheMovie
_King of Marvin Gardens_ is R-rated: (ist MassMediaDataMt (movieAdvisoryRating TheKingOfMarvinGardens-TheMovie RestrictedRating))

Binary predicate associating actors with movies: movieActors
Asserting constraints on #$movieActors, these might take a little while to propagate...
Asserting constraints on #$movieActors-WithStarringRole, these might take a little while to propagate...
Specializations of #$movieActors:
  - movieActors-WithStarringRole

Things that #$JackNicholson is known to be:
  - ActorInMovies
  - Individual
Does Cyc know that #$JackNicholson is a human? true
Jack Nicholson starred in _King of Marvin Gardens_: (ist MassMediaDataMt (movieActors-WithStarringRole TheKingOfMarvinGardens-TheMovie JackNicholson))

Query sentence: (and (movieActors ?MOVIE JackNicholson) (movieAdvisoryRating ?MOVIE RestrictedRating))
Retrieving query answers as a List of binding-sets...
Status: SUSPENDED
Is inference suspended? true
Number of results: 1
 - TheKingOfMarvinGardens-TheMovie
Done with query!

Retrieving query answers as a synchronous QueryResultSet...
Status: SUSPENDED
Is inference suspended? true
Number of results: 1
 - TheKingOfMarvinGardens-TheMovie
Done with query!
