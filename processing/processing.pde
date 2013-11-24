import org.eclipse.egit.github.core.*;
import org.eclipse.egit.github.core.client.*;
import org.eclipse.egit.github.core.service.*;
import processing.serial.*;
import java.util.*;


Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port
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
  if ( event != Event.NOP ) {
    println( event.ordinal() );
    //char c = event.ordinal();
    myPort.write( Character.forDigit( event.ordinal(), 10 ) );
  }
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
    event = Event.SOLVE;
  } else if ( openIssues < newOpenIssues ) {
    event = Event.BUG;
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
    println( event );
  } catch(Exception e) {
    println( e.toString() );
  }
  
  
  delay(10 * 1000);
}

void fetchRepo() throws IOException {
  repo = repoService.getRepository("tvooo", "test");
}

void setup() {
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

