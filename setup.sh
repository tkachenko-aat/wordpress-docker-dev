#!/bin/bash
set -euo pipefail

handle_error() {
    echo "❌ Error on line $1"
    exit 1
}
trap 'handle_error $LINENO' ERR

if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# WordPress Docker Development Environment Setup Script

echo "🚀 Setting up WordPress Development Environment..."

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p config themes plugins uploads

# Create PHP configuration if it doesn't exist
if [ ! -f "config/php.ini" ]; then
    echo "📝 Creating PHP configuration..."
    # The php.ini content would be created by the artifact above
fi

# Start the containers
echo "🐳 Starting Docker containers..."
docker-compose up -d

# Wait for WordPress to be ready
echo "⏳ Waiting for WordPress to initialize..."
sleep 30

# Install WooCommerce via WP-CLI
echo "🛒 Installing WooCommerce..."
docker-compose exec wpcli wp plugin install woocommerce --activate --allow-root

# Install useful development plugins
echo "🔧 Installing development plugins..."
docker-compose exec wpcli wp plugin install query-monitor --activate --allow-root
docker-compose exec wpcli wp plugin install debug-bar --activate --allow-root
docker-compose exec wpcli wp plugin install wp-crontrol --activate --allow-root

# Create a basic theme structure
echo "🎨 Creating basic theme structure..."
mkdir -p themes/dev-theme
cat > themes/dev-theme/style.css << 'EOF'
/*
Theme Name: Development Theme
Description: A basic theme for development purposes
Version: 1.0
*/

body {
    font-family: Arial, sans-serif;
    line-height: 1.6;
    margin: 0;
    padding: 20px;
}
EOF

cat > themes/dev-theme/index.php << 'EOF'
<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
    <meta charset="<?php bloginfo('charset'); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>
    <header>
        <h1><?php bloginfo('name'); ?></h1>
        <p><?php bloginfo('description'); ?></p>
    </header>

    <main>
        <?php if (have_posts()) : ?>
            <?php while (have_posts()) : the_post(); ?>
                <article>
                    <h2><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h2>
                    <div><?php the_content(); ?></div>
                </article>
            <?php endwhile; ?>
        <?php endif; ?>
    </main>

    <?php wp_footer(); ?>
</body>
</html>
EOF

cat > themes/dev-theme/functions.php << 'EOF'
<?php
// Basic theme setup
function dev_theme_setup() {
    add_theme_support('post-thumbnails');
    add_theme_support('woocommerce');
    add_theme_support('wc-product-gallery-zoom');
    add_theme_support('wc-product-gallery-lightbox');
    add_theme_support('wc-product-gallery-slider');
}
add_action('after_setup_theme', 'dev_theme_setup');

// Enqueue styles
function dev_theme_styles() {
    wp_enqueue_style('dev-theme-style', get_stylesheet_uri());
}
add_action('wp_enqueue_scripts', 'dev_theme_styles');
EOF

# Set up permalinks
echo "🔗 Setting up permalinks..."
docker-compose exec wpcli wp rewrite structure '/%postname%/' --allow-root

# Create sample content
echo "📄 Creating sample content..."
docker-compose exec wpcli wp post create --post_title="Welcome to WordPress Development" --post_content="This is your development environment with WooCommerce ready!" --post_status=publish --allow-root

echo "✅ Setup complete!"
echo ""
echo "🌐 Access your sites:"
echo "   WordPress: http://localhost:8080"
echo "   phpMyAdmin: http://localhost:8081"
echo ""
echo "📋 Database credentials:"
echo "   Host: localhost:3306"
echo "   Database: ${MYSQL_DATABASE:-wordpress}"
echo "   Username: ${MYSQL_USER:-wordpress}"
echo "   Password: Check your .env file"
echo ""
echo "🛠️  Development directories:"
echo "   Themes: ./themes/"
echo "   Plugins: ./plugins/"
echo "   Uploads: ./uploads/"
echo ""
echo "🔧 Useful commands:"
echo "   Start: docker-compose up -d"
echo "   Stop: docker-compose down"
echo "   WP-CLI: docker-compose exec wpcli wp [command] --allow-root"
echo "   Logs: docker-compose logs wordpress"
