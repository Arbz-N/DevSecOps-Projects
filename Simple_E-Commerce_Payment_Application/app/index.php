<?php
/**
 * Simple E-Commerce Payment Application
 * For NGINX Load Balancer + Apache Backend Lab
 */

$db_host = 'localhost';
$db_user = 'payment_user';
$db_pass = 'payment_secure_2024';
$db_name = 'payment_db';

try {
    $conn = new mysqli($db_host, $db_user, $db_pass, $db_name);
    if ($conn->connect_error) {
        die('Database Connection Failed: ' . $conn->connect_error);
    }
} catch (Exception $e) {
    die('Error: ' . $e->getMessage());
}

$page = isset($_GET['page']) ? $_GET['page'] : 'home';
$action = isset($_GET['action']) ? $_GET['action'] : '';

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>E-Commerce Payment System - Load Balanced</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
        }

        header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }

        header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
        }

        .server-info {
            background: #fffacd;
            padding: 15px;
            margin: 20px;
            border-radius: 5px;
            border-left: 4px solid #ff6b6b;
        }

        nav {
            background: #f8f9fa;
            padding: 15px 30px;
            border-bottom: 1px solid #ddd;
            display: flex;
            gap: 20px;
            justify-content: center;
        }

        nav a {
            text-decoration: none;
            color: #667eea;
            font-weight: bold;
            padding: 10px 20px;
            border-radius: 5px;
            transition: all 0.3s;
        }

        nav a:hover {
            background: #667eea;
            color: white;
        }

        .content {
            padding: 40px 30px;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }

        .product-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
            transition: all 0.3s;
        }

        .product-card:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transform: translateY(-5px);
        }

        .product-image {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3em;
        }

        .product-info {
            padding: 15px;
        }

        .product-info h3 {
            color: #333;
            margin-bottom: 10px;
        }

        .price {
            color: #667eea;
            font-size: 1.5em;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn:hover {
            transform: scale(1.05);
        }

        .btn-success {
            background: #27ae60;
        }

        .form-group {
            margin: 20px 0;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: bold;
        }

        input, select, textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1em;
        }

        .alert {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        table th {
            background: #667eea;
            color: white;
            padding: 15px;
            text-align: left;
        }

        table td {
            padding: 12px 15px;
            border-bottom: 1px solid #ddd;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }

        .stat-card h3 {
            font-size: 2.5em;
            margin-bottom: 10px;
        }

        footer {
            background: #f8f9fa;
            padding: 20px;
            text-align: center;
            color: #666;
            border-top: 1px solid #ddd;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>🛒 E-Commerce Payment System</h1>
            <p>NGINX Load Balanced + Apache Multi-Backend</p>
        </header>

        <div class="server-info">
            <strong>⚡ Server Information:</strong><br>
            Server: <?php echo $_SERVER['SERVER_SOFTWARE']; ?><br>
            PHP: <?php echo phpversion(); ?><br>
            Hostname: <?php echo gethostname(); ?>
        </div>

        <nav>
            <a href="?page=home">Home</a>
            <a href="?page=products">Products</a>
            <a href="?page=checkout">Checkout</a>
            <a href="?page=admin">Admin Panel</a>
            <a href="?page=status">System Status</a>
        </nav>

        <div class="content">
            <?php

            if ($page == 'home') {
                ?>
                <h2>Welcome to E-Commerce Payment System</h2>
                <div class="alert alert-info">
                    <strong>Load Balanced Architecture:</strong> This application is served through NGINX load balancer distributing requests to multiple Apache backend servers.
                </div>

                <div class="stats">
                    <div class="stat-card">
                        <h3>🌐</h3>
                        <p>NGINX Load Balancer</p>
                    </div>
                    <div class="stat-card">
                        <h3>⚙️</h3>
                        <p>Apache Backend Servers</p>
                    </div>
                    <div class="stat-card">
                        <h3>🗄️</h3>
                        <p>MySQL Database</p>
                    </div>
                </div>
                <?php
            }

            elseif ($page == 'products') {
                ?>
                <h2>Available Products</h2>

                <div class="product-grid">
                    <div class="product-card">
                        <div class="product-image">📱</div>
                        <div class="product-info">
                            <h3>Smartphone</h3>
                            <p>Latest model smartphone</p>
                            <div class="price">$599.99</div>
                            <a href="?page=checkout&product=smartphone" class="btn">Buy Now</a>
                        </div>
                    </div>

                    <div class="product-card">
                        <div class="product-image">💻</div>
                        <div class="product-info">
                            <h3>Laptop</h3>
                            <p>High-performance laptop</p>
                            <div class="price">$999.99</div>
                            <a href="?page=checkout&product=laptop" class="btn">Buy Now</a>
                        </div>
                    </div>

                    <div class="product-card">
                        <div class="product-image">⌚</div>
                        <div class="product-info">
                            <h3>Smart Watch</h3>
                            <p>Fitness tracking watch</p>
                            <div class="price">$299.99</div>
                            <a href="?page=checkout&product=smartwatch" class="btn">Buy Now</a>
                        </div>
                    </div>

                    <div class="product-card">
                        <div class="product-image">🎧</div>
                        <div class="product-info">
                            <h3>Wireless Headphones</h3>
                            <p>Premium sound quality</p>
                            <div class="price">$199.99</div>
                            <a href="?page=checkout&product=headphones" class="btn">Buy Now</a>
                        </div>
                    </div>
                </div>
                <?php
            }

            elseif ($page == 'checkout') {
                $product = isset($_GET['product']) ? $_GET['product'] : 'unknown';
                $products = [
                    'smartphone' => ['name' => 'Smartphone', 'price' => 599.99],
                    'laptop' => ['name' => 'Laptop', 'price' => 999.99],
                    'smartwatch' => ['name' => 'Smart Watch', 'price' => 299.99],
                    'headphones' => ['name' => 'Wireless Headphones', 'price' => 199.99]
                ];

                $prod_data = isset($products[$product]) ? $products[$product] : ['name' => 'Unknown', 'price' => 0];

                if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['process_payment'])) {
                    $customer_name = $conn->real_escape_string($_POST['customer_name']);
                    $customer_email = $conn->real_escape_string($_POST['customer_email']);
                    $card_number = substr($_POST['card_number'], -4);
                    $amount = $prod_data['price'];

                    $sql = "INSERT INTO payments (customer_name, customer_email, product, amount, card_last4, status, created_at)
                            VALUES ('$customer_name', '$customer_email', '$product', $amount, '$card_number', 'completed', NOW())";

                    if ($conn->query($sql)) {
                        ?>
                        <div class="alert alert-success">
                            <strong>Payment Successful!</strong><br>
                            Order ID: #<?php echo rand(10000, 99999); ?><br>
                            Amount: $<?php echo $amount; ?>
                        </div>
                        <?php
                    }
                }
                ?>

                <h2>Checkout - <?php echo $prod_data['name']; ?></h2>

                <form method="POST">
                    <div class="form-group">
                        <label>Customer Name:</label>
                        <input type="text" name="customer_name" required>
                    </div>

                    <div class="form-group">
                        <label>Email:</label>
                        <input type="email" name="customer_email" required>
                    </div>

                    <div class="form-group">
                        <label>Card Number:</label>
                        <input type="text" name="card_number" placeholder="4111 1111 1111 1111" required>
                    </div>

                    <div class="form-group">
                        <label>Amount:</label>
                        <input type="text" value="$<?php echo $prod_data['price']; ?>" disabled>
                    </div>

                    <button type="submit" name="process_payment" class="btn btn-success">Process Payment</button>
                </form>
                <?php
            }

            elseif ($page == 'admin') {
                ?>
                <h2>Admin Panel - Payment Records</h2>

                <table>
                    <tr>
                        <th>ID</th>
                        <th>Customer</th>
                        <th>Product</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Date</th>
                    </tr>
                    <?php
                    $result = $conn->query("SELECT id, customer_name, product, amount, status, created_at FROM payments LIMIT 10");
                    if ($result && $result->num_rows > 0) {
                        while ($row = $result->fetch_assoc()) {
                            echo "<tr>";
                            echo "<td>#" . $row['id'] . "</td>";
                            echo "<td>" . $row['customer_name'] . "</td>";
                            echo "<td>" . $row['product'] . "</td>";
                            echo "<td>$" . $row['amount'] . "</td>";
                            echo "<td>" . $row['status'] . "</td>";
                            echo "<td>" . $row['created_at'] . "</td>";
                            echo "</tr>";
                        }
                    } else {
                        echo "<tr><td colspan='6'>No payments recorded yet</td></tr>";
                    }
                    ?>
                </table>
                <?php
            }

            elseif ($page == 'status') {
                ?>
                <h2>System Status & Information</h2>

                <div class="stats">
                    <div class="stat-card">
                        <h3>🌐</h3>
                        <p>NGINX Load Balancer</p>
                    </div>
                    <div class="stat-card">
                        <h3>⚙️</h3>
                        <p>Apache Backend 1 & 2</p>
                    </div>
                    <div class="stat-card">
                        <h3>✅</h3>
                        <p>MySQL Connected</p>
                    </div>
                    <div class="stat-card">
                        <h3>🔒</h3>
                        <p>All Services Active</p>
                    </div>
                </div>

                <h3>Server Information</h3>
                <table>
                    <tr>
                        <th>Property</th>
                        <th>Value</th>
                    </tr>
                    <tr>
                        <td>Server Software</td>
                        <td><?php echo $_SERVER['SERVER_SOFTWARE']; ?></td>
                    </tr>
                    <tr>
                        <td>PHP Version</td>
                        <td><?php echo phpversion(); ?></td>
                    </tr>
                    <tr>
                        <td>Current Time</td>
                        <td><?php echo date('Y-m-d H:i:s'); ?></td>
                    </tr>
                </table>
                <?php
            }

            else {
                echo '<h2>Page Not Found</h2>';
            }

            $conn->close();
            ?>
        </div>

        <footer>
            <p>&copy; 2024 E-Commerce Payment System | NGINX Load Balancer + Apache Multi-Backend</p>
        </footer>
    </div>
</body>
</html>