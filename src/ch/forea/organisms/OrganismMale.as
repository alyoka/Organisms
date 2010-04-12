package ch.forea.organisms {
	import ch.forea.organisms.AbstractOrganism;

	/**
	 * @author alena
	 */
	public class OrganismMale extends AbstractOrganism {
		public function OrganismMale() {
			
		}
		
		override public function meet(organism:AbstractOrganism):int{
			return organism.sex ? meetMale(organism) : meetFemale(organism);
		}

		private function meetMale(organism:AbstractOrganism):int{
			return -Math.random()*10;
		}
		
		private function meetFemale(organism:AbstractOrganism):int{
			return 10 - Math.random()*20;
		}
		
		
		
//		
//		//@returns -10(agressive) - 0(ignorant)
//		override public function meetMale(organism:AbstractOrganism):int{
////			colourImportance()
////			compareColours(organism.colour)
////			organism.age
////			/ age
////			organism.strength
////			strength
////			agressivness
//			return 0;
//		}
//		
//		//@returns -10(agressive) - +10(attracted)
//		override public function meetFemale(organism:AbstractOrganism):int{
//			return 0;
//		}
//		
//		override public function get colourImportance():Number{
//			return super.colourImportance * 6;	
//		}
	}
}
