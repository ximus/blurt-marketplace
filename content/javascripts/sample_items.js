var SAMPLES = [];  

function random(from, to) {
  return Math.floor(Math.random() * (to - from)) + from;
}

j=random(1,9);
k=1;
for (var i = 50 - 1; i >= 0; i--){
  j++; 
  if (j > 9) {
    j = k;    
    k++;
    if (k > 9) k = random(1,9);
  }
  
  SAMPLES.push({
    title: "Great Offer for You!",
    description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    short_desc: "Buy one and get 5 Free",
    // Random image
    image_url: "images/samples/sample" + j + ".jpg",
    time_left: { days: random(1,15), hours: random(1,24) }
  });
};