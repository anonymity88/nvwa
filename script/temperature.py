import matplotlib.pyplot as plt

# Read the file content
file_path = "/home/llm/test/temperature_new_spirv.txt"
data = {}
with open(file_path, 'r') as file:
    lines = file.readlines()
    temp, duration, successes = None, None, None
    for line in lines:
        line = line.strip()
        if line.startswith("temperature"):
            temp = float(line.split('=')[1].strip(':'))
        elif line.startswith("成功次数"):
            successes = int(line.split('：')[1])
        elif line.startswith("累计时长"):
            duration = float(line.split('：')[1].split()[0])  # Extract the duration in seconds
        if temp is not None and duration is not None and successes is not None:
            data[temp] = {"duration": duration, "seeds": successes}
            temp, duration, successes = None, None, None

# Extract data for plotting
temperatures = sorted(data.keys())
durations = [data[temp]["duration"] for temp in temperatures]
seeds = [data[temp]["seeds"] for temp in temperatures]

# Plot the data with two y-axes
fig, ax1 = plt.subplots(figsize=(10, 6))

# Left y-axis for seeds
ax1.plot(temperatures, seeds, label="seeds", color="yellow", marker="o", linestyle="-")
ax1.set_xlabel("temperature", color="black")
ax1.set_ylabel("seeds", color="black")
ax1.tick_params(axis="y", labelcolor="black")
ax1.tick_params(axis="x", labelcolor="black")
ax1.grid(True)

# Right y-axis for durations
ax2 = ax1.twinx()
ax2.plot(temperatures, durations, label="duration (seconds)", color="blue", marker="o", linestyle="--")
ax2.set_ylabel("duration (seconds)", color="black")
ax2.tick_params(axis="y", labelcolor="black")

# Add legend
lines_1, labels_1 = ax1.get_legend_handles_labels()
lines_2, labels_2 = ax2.get_legend_handles_labels()
ax1.legend(lines_1 + lines_2, labels_1 + labels_2, loc="upper left")

# Title
plt.title("Temperature vs Seeds and Duration", color="black")

# Save the plot as PDF
output_path = "/home/llm/test/temperature_spirv.pdf"
plt.savefig(output_path)
plt.close()

print(f"Plot saved as {output_path}.")
