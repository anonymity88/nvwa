import matplotlib.pyplot as plt
import numpy as np
import re
from scipy.interpolate import make_interp_spline

def parse_file(file_path):
    """
    Parse the .txt file to extract temperature and success count.
    """
    temperatures = []
    success_counts = []
    
    with open(file_path, 'r', encoding='utf-8') as f:
        for line in f:
            temp_match = re.match(r'temperature\s*=\s*([\d.]+):', line)
            success_match = re.match(r'\s*成功次数：(\d+)', line)
            if temp_match:
                temperatures.append(float(temp_match.group(1)))
            elif success_match:
                success_counts.append(int(success_match.group(1)))
    
    return temperatures, success_counts

def smooth_line(x, y, num_points=300):
    """
    Smooth the line using interpolation.
    Ensure x is sorted for make_interp_spline.
    """
    x = np.array(x)
    y = np.array(y)
    
    # Sort x and y based on x values
    sorted_indices = np.argsort(x)
    x_sorted = x[sorted_indices]
    y_sorted = y[sorted_indices]
    
    # Generate smooth curve using cubic spline
    x_new = np.linspace(min(x_sorted), max(x_sorted), num_points)
    spline = make_interp_spline(x_sorted, y_sorted, k=3)  # Cubic spline
    y_smooth = spline(x_new)
    
    return x_new, y_smooth

def plot_statistics(file_paths, legends, output_path):
    """
    Plot the statistics from multiple .txt files with smooth lines.
    """
    plt.figure(figsize=(8, 6))
    
    # Use lighter colors (adjusted with lighter RGB values)
    colors = ['#6699FF', 'orange', '#66CC66', '#CC66CC']  # Light blue, light orange, light green, light purple
    
    # Plot all lines
    for i, file_path in enumerate(file_paths):
        temperatures, success_counts = parse_file(file_path)
        x_smooth, y_smooth = smooth_line(temperatures, success_counts)
        # Use the predefined lighter color for each line
        plt.plot(x_smooth, y_smooth, label=legends[i], color=colors[i], linewidth=4, alpha=0.8, zorder=2)
    
    # Add vertical line for reference
    plt.axvline(x=0.4, color='red', linestyle='--', linewidth=3, zorder=3)  # Adjust vertical line width
    
    # Configure plot appearance
    plt.xlabel('Temperature', fontsize=30, color='black')
    plt.ylabel('Valid Cases', fontsize=30, color='black')
    plt.legend(loc='lower right', bbox_to_anchor=(0.88, 0), fontsize=25)    
    
    # Set x-axis ticks from 0.0 to 1.5, every 0.2
    plt.xticks(np.arange(0.0, 1.6, 0.2), fontsize=25, color='black')
    
    # Set y-axis ticks from 30 to 100, every 10 units
    plt.yticks(np.arange(30, 101, 10), fontsize=25, color='black')
    
    # Adjust tick parameters for both axes
    plt.tick_params(axis='both', which='major', labelsize=25)  # Major tick labels
    plt.tick_params(axis='both', which='minor', labelsize=25)  # Minor tick labels (if any)
    
    # Add grid lines with dashed style at the bottommost layer
    plt.grid(True, linestyle='--', zorder=1)
    
    plt.tight_layout()
    
    # Save the plot to a PDF file
    plt.savefig(output_path)
    plt.close()

# Example usage
file_paths = ['/home/llm/test/temperature_new_affine.txt', '/home/llm/test/temperature_new_linalg.txt', '/home/llm/test/temperature_new_tosa.txt', '/home/llm/test/temperature_new_spirv.txt']  # Replace with actual file paths
output_path = 'test/temperature.pdf'
legends = ['affine', 'linalg', 'tosa', 'spirv']  # Customize legend names
plot_statistics(file_paths, legends, output_path)
