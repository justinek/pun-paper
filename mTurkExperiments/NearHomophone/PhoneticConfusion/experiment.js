/*
Displays each slide
*/

function showSlide(id) {
  $(".slide").hide();
  $("#"+id).show();
}

/* 
Returns random number between a and b, inclusive
*/

function random(a,b) {
  if (typeof b == "undefined") {
    a = a || 2;
    return Math.floor(Math.random()*a);
  } else {
    return Math.floor(Math.random()*(b-a+1)) + a;
  }
}

/* 
Randomly shuffles elements in an array
*/

Array.prototype.random = function() {
  return this[random(this.length)];
}

/* 
Returns random number between a and b, inclusive
*/

function setQuestion(array) {
    var i = random(0, array.length - 1);
    var q = array[i];
    return q;
}

/* 
Produces an array with numbers 0~arrLength
in random order. Kind of spurious--use 
Array.prototype.random instead
*/

function shuffledArray(arrLength)
{
  var j, tmp;
  var arr = new Array(arrLength);
  for (i = 0; i < arrLength; i++)
  {
    arr[i] = i;
  }
  for (i = 0; i < arrLength-1; i++)
  {
    j = Math.floor((Math.random() * (arrLength - 1 - i)) + 0.99) + i;
    tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
  }
  return arr;
}

/* 
Gets the value of the checked radio button
*/

function getRadioCheckedValue(formNum, radio_name)
{
   var oRadio = document.forms[formNum].elements[radio_name];
   for(var i = 0; i < oRadio.length; i++)
   {
      if(oRadio[i].checked)
      {
         return oRadio[i].value;
      }
   }
   return '';
}

/* 
Clears value from form
*/

function clearForm(oForm) {
    
  var elements = oForm.elements; 
    
  oForm.reset();

  for(i=0; i<elements.length; i++) {
      
	field_type = elements[i].type.toLowerCase();
	
	switch(field_type) {
	
		case "text": 
		case "password": 
		case "textarea":
	        case "hidden":	
			
			elements[i].value = ""; 
			break;
        
		case "radio":
		case "checkbox":
  			if (elements[i].checked) {
   				elements[i].checked = false; 
			}
			break;

		case "select-one":
		case "select-multi":
            		elements[i].selectedIndex = -1;
			break;

		default: 
			break;
	}
    }
}


/*
Text input for your experiment. Each array is a condition.
Record all necessary information you may need for each input.
*/

var allConditions = [
/* short debugging trails 
[
{"homophoneID":1,"word1":"LION","word2":"LINE"},
{"homophoneID":2,"word1":"TOOTH","word2":"TRUTH"},
{"homophoneID":3,"word1":"CILIA","word2":"SILLIER"},
{"homophoneID":4,"word1":"HEIR","word2":"HAIR"},
] 
*/
/* full trials */
[
{"homophoneID":1,"word1":"LION","word2":"LINE"},
{"homophoneID":2,"word1":"TOOTH","word2":"TRUTH"},
{"homophoneID":3,"word1":"CILIA","word2":"SILLIER"},
{"homophoneID":4,"word1":"HEIR","word2":"HAIR"},
{"homophoneID":5,"word1":"CLOTHING","word2":"CLOSING"},
{"homophoneID":6,"word1":"AMBIANCE","word2":"AMBULANCE"},
{"homophoneID":7,"word1":"PERCHES","word2":"PURCHASE"},
{"homophoneID":8,"word1":"REWORD","word2":"REWARD"},
{"homophoneID":9,"word1":"MATH","word2":"MASS"},
{"homophoneID":10,"word1":"STEALER","word2":"STEELER"},
{"homophoneID":11,"word1":"WICKER","word2":"WICKED"},
{"homophoneID":12,"word1":"SPATIAL","word2":"SPECIAL"},
{"homophoneID":13,"word1":"WHIRLED","word2":"WORLD"},
{"homophoneID":14,"word1":"CAESARS","word2":"SCISSORS"},
{"homophoneID":15,"word1":"LAUNCH","word2":"LUNCH"},
{"homophoneID":16,"word1":"BLOOM","word2":"BLUE"},
{"homophoneID":17,"word1":"FLEA","word2":"FREE"},
{"homophoneID":18,"word1":"FILLINGS","word2":"FEELINGS"},
{"homophoneID":19,"word1":"SALIVATION","word2":"SALVATION"},
{"homophoneID":20,"word1":"ORIFICE","word2":"OFFICE"},
{"homophoneID":21,"word1":"BRAILLE","word2":"BAIL"},
{"homophoneID":22,"word1":"SPERM","word2":"SPUR"},
{"homophoneID":23,"word1":"GRIME","word2":"CRIME"},
{"homophoneID":24,"word1":"EPOCH","word2":"POCK"},
{"homophoneID":25,"word1":"BONUS","word2":"BONES"},
{"homophoneID":26,"word1":"HOBBIT","word2":"HABIT"},
{"homophoneID":27,"word1":"SCREAMING","word2":"SCREENING"},
{"homophoneID":28,"word1":"OHMS","word2":"HOLMES"},
{"homophoneID":29,"word1":"KANT","word2":"CAN'T"},
{"homophoneID":30,"word1":"TAMPER","word2":"TEMPER"},
{"homophoneID":31,"word1":"LATTE","word2":"LATE"},
{"homophoneID":32,"word1":"LIBEL","word2":"LIABLE"},
{"homophoneID":33,"word1":"TRYST","word2":"TWIST"},
{"homophoneID":34,"word1":"PROPANE","word2":"PROFANE"},
{"homophoneID":35,"word1":"LEAFING","word2":"LEAVING"},
{"homophoneID":36,"word1":"YAMS","word2":"LAMBS"},
{"homophoneID":37,"word1":"TOLKIEN","word2":"TALKING"},
{"homophoneID":38,"word1":"MAGNATE","word2":"MAGNET"},
{"homophoneID":39,"word1":"RAVEN","word2":"RAVING"},
{"homophoneID":40,"word1":"ALKALINE","word2":"ALCOHOL"},
{"homophoneID":41,"word1":"SHAVE","word2":"SLAVE"},
{"homophoneID":42,"word1":"AIKEN","word2":"ACHING"},
{"homophoneID":43,"word1":"IRRIGATION","word2":"IRRITATION"},
{"homophoneID":44,"word1":"AUNTIE","word2":"ANTE"},
{"homophoneID":45,"word1":"FUCHSIA","word2":"FUTURE"},
{"homophoneID":46,"word1":"TILL","word2":"TELL"},
{"homophoneID":47,"word1":"HOUSE","word2":"HOW'S"},
{"homophoneID":48,"word1":"EIRE","word2":"FIRE"},
{"homophoneID":49,"word1":"ALP","word2":"HELP"},
{"homophoneID":50,"word1":"GARDEN","word2":"GUARDING"},
{"homophoneID":51,"word1":"BEAN","word2":"BEEN"},
{"homophoneID":52,"word1":"ODOR","word2":"ORDER"},
{"homophoneID":53,"word1":"WATT","word2":"LOT"},
{"homophoneID":54,"word1":"PEST","word2":"BEST"},
{"homophoneID":55,"word1":"CRANK","word2":"CRACK"},
{"homophoneID":56,"word1":"LEG","word2":"LAG"},
{"homophoneID":57,"word1":"DECADE","word2":"DECAY"},
{"homophoneID":58,"word1":"DRAMATIC","word2":"TRAUMATIC"},
{"homophoneID":59,"word1":"GRAMMATIC","word2":"TRAUMATIC"},
{"homophoneID":60,"word1":"HOSTA","word2":"HOSTILE"},
{"homophoneID":61,"word1":"DUBLIN","word2":"DOUBLING"},
{"homophoneID":62,"word1":"PRISM","word2":"PRISON"},
{"homophoneID":63,"word1":"FRIDGE","word2":"BRIDGE"},
{"homophoneID":64,"word1":"THIEF","word2":"CHIEF"},
{"homophoneID":65,"word1":"REVOLUTION","word2":"RESOLUTION"},
{"homophoneID":66,"word1":"PLANTS","word2":"PANTS"},
{"homophoneID":67,"word1":"INCISOR","word2":"INSIDER"},
{"homophoneID":68,"word1":"MIMES","word2":"MINDS"},
{"homophoneID":69,"word1":"GLITTERING","word2":"LITTERING"},
{"homophoneID":70,"word1":"ALTITUDE","word2":"ATTITUDE"},
{"homophoneID":71,"word1":"PRESENCE","word2":"PRESENTS"},
{"homophoneID":72,"word1":"NECKS","word2":"NEXT"},
{"homophoneID":73,"word1":"DIGESTION","word2":"DESTRUCTION"},
{"homophoneID":74,"word1":"REAM","word2":"CREAM"},
{"homophoneID":75,"word1":"SEIZE","word2":"SEE"},
{"homophoneID":76,"word1":"AUTHOR","word2":"OFFER"},
{"homophoneID":77,"word1":"SOURCE","word2":"SAUCE"},
{"homophoneID":78,"word1":"PASTE","word2":"PAYS"},
{"homophoneID":79,"word1":"ESPRESSO","word2":"EXPRESS"},
{"homophoneID":80,"word1":"SCENTS","word2":"SENSE"},
]
];

/*
Set variables
*/

// Number of conditions in experiment
var numConditions = allConditions.length;

// Randomly select a condition number for this particular participant
var chooseCondition = random(0, numConditions-1);

// Based on condition number, choose set of input (trials)
var allTrialOrders = allConditions[chooseCondition];

// Number of trials in each condition
var numTrials = allTrialOrders.length;

// Produce random order in which the trials will occur
var shuffledOrder = shuffledArray(numTrials);

// Keep track of current trial 
var currentTrialNum = 0;

// A variable special for this experiment because we're randomly
// choosing word orders as well
var wordOrder = 100;
var trial;

// Keep track of how many trials have been completed
var numComplete = 0;

// Show instruction slide
showSlide("instructions");

// Updates the progress bar
$("#trial-num").html(numComplete);
$("#total-num").html(numTrials);

/*
The actual variable that will be returned to MTurk.
An experiment object with various variables that you
want to keep track of and return as results.
*/
var experiment = {
	// Which condition was run
	//condition: chooseCondition + 1,
	
	// An array of subjects' responses to each trial (NOTE: in the order in which
	// you initially listed the trials, not in the order in which they appeared)
    results: new Array(numTrials),
    
    homophoneIDs: new Array(numTrials),
    
    // The order in which each trial appeared
    orders: new Array(numTrials),
    
    /* 
    Special for this experiment
    */
    // The word order of the word pair, i.e. [word1, word] vs [word2, word1]
    //wordOrders: new Array(numTrials),
    //isPuns: new Array(numTrials),
    //isCorrects: new Array(numTrials), 
    
    // Demographics
    gender: "",
    age:"",
    nativeLanguage:"",
    comments:"",
    
    /* 
    Functions for the experiment. Gets called from html
    when people press a button to the next page or to submit
    results, etc
    */
    
    // Goes to description slide
    description: function() {
    	showSlide("description");
    	$("#tot-num").html(numTrials);	
    },
    
    // Goes to example slide
    example1: function() {
    	showSlide("example1");
    },
    example2: function() {
    	showSlide("example2");
    },
    
    // Reaches end of survey, submits results
    end: function() {
    
	// Records demographics
        var gen = getRadioCheckedValue(1, "genderButton");
        var ag = document.age.ageRange.value;
        var lan = document.language.nativeLanguage.value;
        var comm = document.comments.input.value;
        experiment.gender = gen;
        experiment.age = ag;
        experiment.nativeLanguage = lan;
        experiment.comments = comm;
        clearForm(document.forms[1]);
        clearForm(document.forms[2]);
        clearForm(document.forms[3]);
        clearForm(document.forms[4]);
        
        // Show finished slide
        showSlide("finished");
        setTimeout(function() {turk.submit(experiment) }, 1500);
    },
    // Goes to next trial
    next: function() {
    
    // If this is not the first trial, record variables
    	if (numComplete > 0) {
    		
    		var rating = parseInt(getRadioCheckedValue(0, "confusability"));
        	experiment.results[currentTrialNum] = rating;
        	experiment.orders[currentTrialNum] = numComplete;
        	//experiment.wordOrders[currentTrialNum] = wordOrder;
        	experiment.homophoneIDs[currentTrialNum] = trial.homophoneID;
        	//experiment.isPuns[currentTrialNum] = trial.isPun;
        	//experiment.isCorrects[currentTrialNum] = trial.isCorrect;
        	clearForm(document.forms[0]);
        }
    	// If subject has completed all trials, update progress bar and
    	// show slide to ask for demographic info
    	if (numComplete >= numTrials) {
    		$('.bar').css('width', (200.0 * numComplete/numTrials) + 'px');
    		$("#trial-num").html(numComplete);
    		$("#total-num").html(numTrials);
    		showSlide("askInfo");
    	// Otherwise, if trials not completed yet, update progress bar
    	// and go to next trial based on the order in which trials are supposed
    	// to occur
    	} else {
    		$('.bar').css('width', (200.0 * numComplete/numTrials) + 'px');
    		$("#trial-num").html(numComplete);
    		$("#total-num").html(numTrials);
    		$("#condition").html(experiment.condition);
    		currentTrialNum = shuffledOrder[numComplete];
    		trial = allTrialOrders[currentTrialNum];
        	showSlide("stage");
        	$("#word1a").html(trial.word1);
        	$("#word2a").html(trial.word2);
        	$("#word1b").html(trial.word1);
        	$("#word2b").html(trial.word2);
        	wordOrder = 0;
        	numComplete++;
        }
    }
}


