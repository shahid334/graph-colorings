/************* PARAMS ***************/
/*
  This file contains Parameters, Data structure and Global Variables used in program
*/

/************* PARAMS ***************/
enum {NOCHECK,TOCHECK};
enum {RANDOM_MOVE,MAX_CONFLICT_MOVE};

const double nAntsPercent = .2 ; 
const int nCyclesFactor = 6 ; //nCycles = this * nVertices, TVN todo: this is too much cycles
const double nJoltPercent = .5 ; 
const double nBreakCycleFactor = 2.5;
const double moveLimitPercent=.25;
const double rSizeLimitFactor=3;
const double RLFSetPercent = .7 ; 
const int XLRF_METHOD = 0 ; //0 = adj density based, ertex w/ largest density chosen for MXRLF

const double ALPHA = .7 ;  //although said .8 but it is hard coded .7 in KA's code
const double BETA = .5 ; 
const double DELTA = .7 ; 

const int HOW_FAR=2;

const int MOVE_METHOD = RANDOM_MOVE;
const int Q_CHANGE_CYCLE=20;


/************* DATA TYPE ***************/
struct vertex{
  int v_id;
  vector<int>adj;
  vector<int>edgeList;
  int numAnts; 
};

/*struct edge{
  int e_id;
  int pOnEdge;
  };
*/

struct ant{
  int a_id;
  vertex *current;
  vertex *old;
};


/************* GLOBAL ***************/
time_t seed_t = 0;
int nVertices=0;
int nEdges=0;
int nAnts=0;
int nCycles=0;
int nJolts=0;
int breakCycles=0;
int moveLimit=0;
int rSizeLimit=0;
int nRLFSetLimit=0;
char* inputFile="";

int bestCycle=0;


vertex **pVertices;
//edge **pEdges;
vector<ant *> vAnts ; // if going to delete ants, then probably use linked list 


bool BB=false ;//debug option


//results stores here
vector<int>bestColorResult;
int bestResult=-1;

//equiv to Patel's neighborhood and WILL be modified, currently it's HUGE!,  
//TVN Todo : convert to vector<vector<int> > 
// Idea : can do a half matrix kind thing ....  ,  isEdge(i,j)  return matrix(smaller(i,j),larger(i,j));
//int **superMatrix;  
//vector<vector <int> >sMatrix;
//vector<vector<int> > adjMatrix; //todo : change to bool later, reason to leave here is to allow -1 for testing purpose
