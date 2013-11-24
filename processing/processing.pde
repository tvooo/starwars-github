import org.eclipse.egit.github.core.*;
import org.eclipse.egit.github.core.client.*;
import org.eclipse.egit.github.core.service.*;
import processing.serial.*;
import java.util.*;
import ddf.minim.*;

Minim minim;
AudioPlayer player;

int SECOND = 1000;

Serial myPort;  // Create object from Serial class
Config config = new Config();

RepositoryService repoService;
IssueService issueService;
Repository repo;

int openIssues;
int stargazers;
int comments;
int forks;
Date date;

void sendEvent( Event event ) {
  if ( event == Event.NOP ) return;
  myPort.write( Character.forDigit( event.ordinal(), 10 ) );
}

void playEvent( Event event ) {
  if ( event == Event.NOP ) return;
  String filename = event.name().toLowerCase() + "0" + str(int(random(1,7)));
  player = minim.loadFile("sounds/" + filename + ".wav");
  player.play();
}

void initVariables() throws IOException {
  openIssues = repo.getOpenIssues();
  stargazers = repo.getWatchers();
  date = repo.getPushedAt();
  forks = repo.getForks();
  
  comments = 0;
  for( Issue issue : issueService.getIssues(repo, new HashMap<String,String>())) {
    comments += issue.getComments();
  }
}

Event getEvent() throws IOException {
  Event event = Event.NOP;
  
  int newOpenIssues = repo.getOpenIssues();
  int newStargazers = repo.getWatchers();
  int newForks = repo.getForks();
  Date newDate = repo.getPushedAt();
  int newComments = 0;
  
  for( Issue issue : issueService.getIssues(repo, new HashMap<String,String>())) {
    newComments += issue.getComments();
  }
  
  if ( openIssues > newOpenIssues ) {
    event = Event.SOLVED;
  } else if ( openIssues < newOpenIssues ) {
    event = Event.ISSUE;
  } else if ( stargazers < newStargazers ) {
    event = Event.STAR;
  } else if ( date.before( newDate ) ) {
    event = Event.COMMIT;
  } else if ( comments < newComments ) {
    event = Event.COMMENT;
  } else if ( forks < newForks ) {
    event = Event.FORK;
  }
  
  openIssues = newOpenIssues;
  stargazers = newStargazers;
  comments = newComments;
  date = newDate;
  forks = newForks;
  
  return event;
}

void draw() {
  Event event;
  
  try {
    fetchRepo();
    event = getEvent();
    sendEvent( event );
    playEvent( event );
    println( event );
  } catch(Exception e) {
    println( e.toString() );
  }
  
  delay(10 * SECOND);
}

void fetchRepo() throws IOException {
  repo = repoService.getRepository(config.repoUser, config.repoName);
}

void setup() {
  minim = new Minim(this);
  String portName = Serial.list()[4];
  //println(Serial.list());
  myPort = new Serial(this, portName, 9600);
  
  repoService = new RepositoryService();
  repoService.getClient().setCredentials( config.user, config.password );
  
  try {
    issueService = new IssueService( repoService.getClient() );
    fetchRepo();
    initVariables();
  } catch (Exception e) {
    println( e.toString() );
  }
}

