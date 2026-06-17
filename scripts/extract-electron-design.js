const fs = require('fs');
const path = require('path');

function extractColorsFromCSS(cssContent) {
    const colors = {};
    
    const varRegex = /--([a-z0-9-]+)\s*:\s*(#[0-9a-fA-F]{3,8}|rgb\([^)]+\)|rgba\([^)]+\)|[a-zA-Z]+)/gi;
    let match;
    while ((match = varRegex.exec(cssContent)) !== null) {
        colors[match[1]] = match[2].trim();
    }
    
    const hexRegex = /color:\s*(#[0-9a-fA-F]{3,8})/gi;
    while ((match = hexRegex.exec(cssContent)) !== null) {
        if (!Object.values(colors).includes(match[1])) {
            colors[`hex-${match[1].replace('#', '')}`] = match[1];
        }
    }
    
    const bgRegex = /background-color:\s*(#[0-9a-fA-F]{3,8})/gi;
    while ((match = bgRegex.exec(cssContent)) !== null) {
        if (!Object.values(colors).includes(match[1])) {
            colors[`bg-${match[1].replace('#', '')}`] = match[1];
        }
    }
    
    return colors;
}

function extractTypographyFromCSS(cssContent) {
    const typography = {
        fontFamily: new Set(),
        fontSize: new Set(),
        fontWeight: new Set(),
        lineHeight: new Set()
    };
    
    const fontRegex = /font-family:\s*([^;]+)/gi;
    let match;
    while ((match = fontRegex.exec(cssContent)) !== null) {
        const fonts = match[1].split(',').map(f => f.trim().replace(/['"]/g, ''));
        fonts.forEach(f => typography.fontFamily.add(f));
    }
    
    const sizeRegex = /font-size:\s*([^;]+)/gi;
    while ((match = sizeRegex.exec(cssContent)) !== null) {
        typography.fontSize.add(match[1].trim());
    }
    
    const weightRegex = /font-weight:\s*([^;]+)/gi;
    while ((match = weightRegex.exec(cssContent)) !== null) {
        typography.fontWeight.add(match[1].trim());
    }
    
    const lineRegex = /line-height:\s*([^;]+)/gi;
    while ((match = lineRegex.exec(cssContent)) !== null) {
        typography.lineHeight.add(match[1].trim());
    }
    
    return {
        fontFamily: Array.from(typography.fontFamily),
        fontSize: Array.from(typography.fontSize),
        fontWeight: Array.from(typography.fontWeight),
        lineHeight: Array.from(typography.lineHeight)
    };
}

function extractSpacingFromCSS(cssContent) {
    const spacing = {
        margin: new Set(),
        padding: new Set(),
        gap: new Set()
    };
    
    const marginRegex = /margin(?:-[a-z])?:\s*([^;]+)/gi;
    let match;
    while ((match = marginRegex.exec(cssContent)) !== null) {
        spacing.margin.add(match[1].trim());
    }
    
    const paddingRegex = /padding(?:-[a-z])?:\s*([^;]+)/gi;
    while ((match = paddingRegex.exec(cssContent)) !== null) {
        spacing.padding.add(match[1].trim());
    }
    
    const gapRegex = /gap:\s*([^;]+)/gi;
    while ((match = gapRegex.exec(cssContent)) !== null) {
        spacing.gap.add(match[1].trim());
    }
    
    return {
        margin: Array.from(spacing.margin),
        padding: Array.from(spacing.padding),
        gap: Array.from(spacing.gap)
    };
}

function extractComponentsFromCSS(cssContent) {
    const components = {};
    
    const classRegex = /\.(btn|button|card|panel|input|select|dropdown|menu|toolbar|sidebar|dialog|modal|tab|badge|chip|avatar|tooltip|progress|slider|switch|checkbox|radio|textarea|label|icon|badge|breadcrumb|pagination|table|header|footer|nav|list|tree|accordion|form|grid|flex|container|wrapper|content|section|article|aside|main)\-/gi;
    let match;
    while ((match = classRegex.exec(cssContent)) !== null) {
        const componentType = match[1];
        if (!components[componentType]) {
            components[componentType] = [];
        }
    }
    
    const componentClasses = /\.(btn|button|card|panel|input|select|dropdown|menu|toolbar|sidebar|dialog|modal|tab|badge|chip|avatar|tooltip|progress|slider|switch|checkbox|radio|textarea|label|icon|breadcrumb|pagination|table|header|footer|nav|list|tree|accordion|form)\b/gi;
    while ((match = componentClasses.exec(cssContent)) !== null) {
        const componentType = match[1];
        if (!components[componentType]) {
            components[componentType] = [];
        }
    }
    
    return components;
}

function extractFromThemeJson(themePath) {
    if (!fs.existsSync(themePath)) {
        return {};
    }
    
    try {
        const content = fs.readFileSync(themePath, 'utf8');
        const theme = JSON.parse(content);
        return theme;
    } catch (error) {
        return {};
    }
}

function analyzeElectronProject(projectPath) {
    console.log(`\n======================================`);
    console.log(`Analyzing Electron Project: ${projectPath}`);
    console.log(`======================================\n`);
    
    const results = {
        colors: {},
        typography: {},
        spacing: {},
        components: {},
        theme: {}
    };
    
    const srcDir = path.join(projectPath, 'src');
    const rendererDir = path.join(srcDir, 'renderer');
    const stylesDir = path.join(rendererDir, 'styles');
    const themeDir = path.join(rendererDir, 'theme');
    
    if (fs.existsSync(stylesDir)) {
        console.log('Scanning styles directory...');
        const cssFiles = fs.readdirSync(stylesDir).filter(f => f.endsWith('.css') || f.endsWith('.scss') || f.endsWith('.sass'));
        
        cssFiles.forEach(file => {
            const filePath = path.join(stylesDir, file);
            const content = fs.readFileSync(filePath, 'utf8');
            
            console.log(`  - Processing: ${file}`);
            
            const fileColors = extractColorsFromCSS(content);
            Object.assign(results.colors, fileColors);
            
            const fileTypography = extractTypographyFromCSS(content);
            Object.keys(fileTypography).forEach(key => {
                if (!results.typography[key]) {
                    results.typography[key] = [];
                }
                fileTypography[key].forEach(value => {
                    if (!results.typography[key].includes(value)) {
                        results.typography[key].push(value);
                    }
                });
            });
            
            const fileSpacing = extractSpacingFromCSS(content);
            Object.keys(fileSpacing).forEach(key => {
                if (!results.spacing[key]) {
                    results.spacing[key] = [];
                }
                fileSpacing[key].forEach(value => {
                    if (!results.spacing[key].includes(value)) {
                        results.spacing[key].push(value);
                    }
                });
            });
            
            const fileComponents = extractComponentsFromCSS(content);
            Object.assign(results.components, fileComponents);
        });
    }
    
    if (fs.existsSync(themeDir)) {
        console.log('\nScanning theme directory...');
        const themeFiles = fs.readdirSync(themeDir).filter(f => f.endsWith('.json'));
        
        themeFiles.forEach(file => {
            const filePath = path.join(themeDir, file);
            console.log(`  - Processing: ${file}`);
            const theme = extractFromThemeJson(filePath);
            Object.assign(results.theme, theme);
        });
    }
    
    console.log('\n=== Extracted Colors ===');
    Object.keys(results.colors).sort().forEach(key => {
        console.log(`  ${key}: ${results.colors[key]}`);
    });
    
    console.log('\n=== Extracted Typography ===');
    Object.keys(results.typography).forEach(key => {
        console.log(`  ${key}: ${results.typography[key].join(', ')}`);
    });
    
    console.log('\n=== Extracted Spacing ===');
    Object.keys(results.spacing).forEach(key => {
        console.log(`  ${key}: ${results.spacing[key].join(', ')}`);
    });
    
    console.log('\n=== Identified Components ===');
    Object.keys(results.components).sort().forEach(key => {
        console.log(`  - ${key}`);
    });
    
    return results;
}

if (require.main === module) {
    const projectPath = process.argv[2];
    if (!projectPath) {
        console.error('Usage: node extract-electron-design.js <project-path>');
        process.exit(1);
    }
    
    analyzeElectronProject(projectPath);
}

module.exports = {
    extractColorsFromCSS,
    extractTypographyFromCSS,
    extractSpacingFromCSS,
    extractComponentsFromCSS,
    extractFromThemeJson,
    analyzeElectronProject
};