import matplotlib.pyplot as plt
import os
import numpy as np

def plot_interactions(output_path, line1_data, line2_data):
    """
    Plots a cumulative chart with interactions on the x-axis and case accumulation ratio on the y-axis.

    Parameters:
    - output_path: Path to save the PDF.
    - line1_data: List of counts for the first line.
    - line2_data: List of counts for the second line.
    """
    # Define x-axis labels and data
    x_labels = [str(i) for i in range(1, 11)]
    x_values = list(range(1, 11))  # No failures in this case

    # Calculate cumulative sums
    cumulative_line1 = np.cumsum(line1_data)
    cumulative_line2 = np.cumsum(line2_data)

    # Normalize the cumulative sums to get the accumulation ratio
    total_line1 = cumulative_line1[-1]  # Total cases for line1
    total_line2 = cumulative_line2[-1]  # Total cases for line2

    if total_line1 != 0:
        cumulative_line1_ratio = cumulative_line1 / total_line1 * 100
    else:
        cumulative_line1_ratio = cumulative_line1

    if total_line2 != 0:
        cumulative_line2_ratio = cumulative_line2 / total_line2 * 100
    else:
        cumulative_line2_ratio = cumulative_line2

    # Create the figure and axis
    fig, ax = plt.subplots(figsize=(8, 6))

    # Plot the cumulative lines
    ax.plot(x_values, cumulative_line1_ratio, marker="o", label="Nüwa-Gen", linewidth=3, markersize=8)
    ax.plot(x_values, cumulative_line2_ratio, marker="s", label="Nüwa-Mut", linewidth=3, markersize=8)

    # Add a vertical dashed red line at x = 3
    ax.axvline(x=4, color='red', linestyle='--', linewidth=2.5)

    # Customize the plot
    ax.set_xticks(x_values)
    ax.set_xticklabels(x_labels, rotation=0, ha="center")

    # Set x-axis and y-axis ranges and ticks
    ax.set_xlabel("Interactions", fontsize=30)
    ax.set_ylabel("Cumulative Success Rate(%)", fontsize=25)

    # Set x-axis ticks from 1 to 10 (each 1 unit)
    ax.set_xticks(np.arange(1, 11, 1))

    # Set y-axis ticks from 60 to 100 (every 5 units)
    ax.set_yticks(np.arange(60, 101, 5))

    # Tick parameters and legend
    ax.tick_params(axis='both', labelsize=25)
    ax.legend(loc='lower right', fontsize=25)

    # Add grid
    ax.grid(visible=True, linestyle="--", alpha=0.7)

    # Ensure the output directory exists
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    # Save the figure
    plt.tight_layout()
    plt.savefig(output_path, format="pdf")
    plt.close()

# Example usage
line1_data = [79, 14, 4, 1, 0, 0, 0, 0, 0, 2]  # Replace with your data
line2_data = [68, 17, 8, 2, 1, 2, 1, 1, 0, 0]   # Replace with your data
output_path = "test/interactions.pdf"

plot_interactions(output_path, line1_data, line2_data)
