const products = [
	{
		name: 'Rau sống',
		price: 10,
		image: 'https://placeholder.com/150'
	},
	{
		name: 'Củ tươi',
		price: 20,
		image: 'https://placeholder.com/150'
	}
];

function renderProducts() {
	const productContainer = document.querySelector('main ul');
	productContainer.innerHTML = '';

	products.forEach((product) => {
		const productItem = `
			<li>
				<img src="${product.image}" alt="${product.name}"/>
				<h3>${product.name}</h3>
				<p>Giá: ${product.price}.000 VND/kg</p>
				<button onclick="addToCart('${product.name}', ${product.price})">Mua hàng</button>
			</li>
		`;
		productContainer.innerHTML += productItem;
	});
}

function addToCart(name, price) {
	const cartContainer = document.querySelector('#cart ul');
	const cartItem = `
		<li>${name} - ${price}.000 VND/kg</li>
	`;
	cartContainer.innerHTML += cartItem;

	const totalContainer = document.querySelector('#cart p');
	const currentTotal = parseInt(totalContainer.textContent);
	const newTotal = currentTotal + price;
	totalContainer.textContent = newTotal.toString();
}
