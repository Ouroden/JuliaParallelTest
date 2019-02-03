function createScript()
{
  cat template.sh | sed -e 's/CPUS/'$1'/g' > script.sh
}

for cpus in {1..12}
do
  createScript $cpus
  sbatch script.sh
done

rm script.sh
