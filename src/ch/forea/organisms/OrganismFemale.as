package ch.forea.organisms {
	import ch.forea.organisms.AbstractOrganism;

	/**
	 * @author alena
	 */
	public class OrganismMale extends AbstractOrganism {
		public function OrganismMale() {
		}
		
		override public function get colourImportance():Number{
			return super.colourImportance * 6;	
		}
	}
}
