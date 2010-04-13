package org.jbei.registry.utils
{
	import mx.collections.ArrayCollection;
	
	import org.jbei.registry.models.Entry;
	import org.jbei.registry.models.Feature;
	import org.jbei.registry.models.Link;
	import org.jbei.registry.models.Name;
	import org.jbei.registry.models.PartNumber;
	import org.jbei.registry.models.Plasmid;
	import org.jbei.registry.models.Sequence;
	import org.jbei.registry.models.SequenceFeature;
	
	public class StandaloneUtils
	{
		public static function standaloneEntry():Entry
		{
			var plasmid:Plasmid = new Plasmid();
			plasmid.alias = "Standalone Alias";
			plasmid.backbone = "Standalone BB";
			plasmid.circular = true;
			plasmid.creationTime = new Date();
			plasmid.creator = "Zinovii Dmytriv";
			plasmid.creatorEmail = "zdmytriv@lbl.gov";
			plasmid.keywords = null;
			plasmid.links = new ArrayCollection();
			plasmid.links.addItem(new Link("http://google.com", "JBEI:Standalone"));
			plasmid.longDescription = "Standalone part long description";
			plasmid.modificationTime = null;
			plasmid.names = new ArrayCollection();
			plasmid.names.addItem(new Name("pNJH-0006"));
			plasmid.originOfReplication = "Standalone OOR";
			plasmid.owner = "Zinovii Dmytriv";
			plasmid.ownerEmail = "zdmytriv@lbl.gov";
			plasmid.partNumbers = new ArrayCollection();
			plasmid.partNumbers.addItem(new PartNumber("JBz_000001"));
			plasmid.promoters = "Promoter1, Promoter2";
			plasmid.recordId = "12345678-12345678-12345678-123456781111";
			plasmid.recordType = "plasmid";
			plasmid.references = "Standalone references";
			plasmid.shortDescription = "Short Description";
			plasmid.status = "public";
			plasmid.versionId = "12345678-12345678-12345678-123456781111";
			
			return plasmid;
		}
		
		public static function standaloneSequence():Sequence {
			var sequence:Sequence = new Sequence();
			
			sequence.fwdHash = "";
			sequence.revHash = "";
			sequence.sequence = "gacgtcggtgcctaatgagtgagctaacttacattaattgcgttgcgctcactgcccgctttccagtcgggaaacctgtcgtgccagctgcattaatgaatcggccaacgcgcggggagaggcggtttgcgtattgggcgccagggtggtttttcttttcaccagtgagacgggcaacagctgattgcccttcaccgcctggccctgagagagttgcagcaagcggtccacgctggtttgccccagcaggcgaaaatcctgtttgatggtggttaacggcgggatataacatgagctgtcttcggtatcgtcgtatcccactaccgagatgtccgcaccaacgcgcagcccggactcggtaatggcgcgcattgcgcccagcgccatctgatcgttggcaaccagcatcgcagtgggaacgatgccctcattcagcatttgcatggtttgttgaaaaccggacatggcactccagtcgccttcccgttccgctatcggctgaatttgattgcgagtgagatatttatgccagccagccagacgcagacgcgccgagacagaacttaatgggcccgctaacagcgcgatttgctggtgacccaatgcgaccagatgctccacgcccagtcgcgtaccgtcttcatgggagaaaataatactgttgatgggtgtctggtcagagacatcaagaaataacgccggaacattagtgcaggcagcttccacagcaatggcatcctggtcatccagcggatagttaatgatcagcccactgacgcgttgcgcgagaagattgtgcaccgccgctttacaggcttcgacgccgcttcgttctaccatcgacaccaccacgctggcacccagttgatcggcgcgagatttaatcgccgcgacaatttgcgacggcgcgtgcagggccagactggaggtggcaacgccaatcagcaacgactgtttgcccgccagttgttgtgccacgcggttgggaatgtaattcagctccgccatcgccgcttccactttttcccgcgttttcgcagaaacgtggctggcctggttcaccacgcgggaaacggtctgataagagacaccggcatactctgcgacatcgtataacgttactggtttcacattcaccaccctgaattgactctcttccgggcgctatcatgccataccgcgaaaggttttgcgccattcgatggtgtccgggatctcgacgctctcccttatgcgactcctgcattaggaagcagcccagtagtaggttgaggccgttgagcaccgccgccgcaaggaatggtgcatgcaaggagatggcgcccaacagtcccccggccacggggcctgccaccatacccacgccgaaacaagcgctcatgagcccgaagtggcgagcccgatcttccccatcggtgatgtcggcgatataggcgccagcaaccgcacctgtggcgccggtgatgccggccacgatgcgtccggcgtagaggatcgagatcgtttaggcaccccaggctttacactttatgcttccggctcgtataatgtgtggaattgtgagcggataacaatttcagaattcaaaagatcttttaagaaggagatatacatatgaagaaggtttggcttaaccgttatcccgcggacgttccgacggagatcaaccctgaccgttatcaatctctggtagatatgtttgagcagtcggtcgcgcgctacgccgatcaacctgcgtttgtgaatatgggggaggtaatgaccttccgcaagctggaagaacgcagtcgcgcgtttgccgcttatttgcaacaagggttggggctgaagaaaggcgatcgcgttgcgttgatgatgcctaatttattgcaatatccggtggcgctgtttggcattttgcgtgccgggatgatcgtcgtaaacgttaacccgttgtataccccgcgtgagcttgagcatcagcttaacgatagcggcgcatcggcgattgttatcgtgtctaactttgctcacacactggaaaaagtggttgataaaaccgccgttcagcacgtaattctgacccgtatgggcgatcagctatctacggcaaaaggcacggtagtcaatttcgttgttaaatacatcaagcgtttggtgccgaaataccatctgccagatgccatttcatttcgtagcgcactgcataacggctaccggatgcagtacgtcaaacccgaactggtgccggaagatttagcttttctgcaatacaccggcggcaccactggtgtggcgaaaggcgcgatgctgactcaccgcaatatgctggcgaacctggaacaggttaacgcgacctatggtccgctgttgcatccgggcaaagagctggtggtgacggcgctgccgctgtatcacatttttgccctgaccattaactgcctgctgtttatcgaactgggtgggcagaacctgcttatcactaacccgcgcgatattccagggttggtaaaagagttagcgaaatatccgtttaccgctatcacgggcgttaacaccttgttcaatgcgttgctgaacaataaagagttccagcagctggatttctccagtctgcatctttccgcaggcggtgggatgccagtgcagcaagtggtggcagagcgttgggtgaaactgaccggacagtatctgctggaaggctatggccttaccgagtgtgcgccgctggtcagcgttaacccatatgatattgattatcatagtggtagcatcggtttgccggtgccgtcgacggaagccaaactggtggatgatgatgataatgaagtaccaccaggtcaaccgggtgagctttgtgtcaaaggaccgcaggtgatgctgggttactggcagcgtcccgatgctaccgatgaaatcatcaaaaatggctggttacacaccggcgacatcgcggtaatggatgaagaaggattcctgcgcattgtcgatcgtaaaaaagacatgattctggtttccggttttaacgtctatcccaacgagattgaagatgtcgtcatgcagcatcctggcgtacaggaagtcgcggctgttggcgtaccttccggctccagtggtgaagcggtgaaaatcttcgtagtgaaaaaagatccatcgcttaccgaagagtcactggtgactttttgccgccgtcagctcacgggatacaaagtaccgaagctggtggagtttcgtgatgagttaccgaaatctaacgtcggaaaaattttgcgacgagaattacgtgacgaagcgcgcggcaaagtggacaataaagcctgaactagtaaggaggaaacagaatgcgcccattacatccgattgattttatattcctgtcactagaaaaaagacaacagcctatgcatgtaggtggtttatttttgtttcagattcctgataacgccccagacacctttattcaggatctggtgaatgatatccggatatcaaaatcaatccctgttccaccattcaacaataaactgaatgggcttttttgggatgaagatgaagagtttgatttagatcatcattttcgtcatattgcactgcctcatcctggtcgtattcgtgaattgcttatttatatttcacaagagcacagtacgctgctagatcgggcaaagcccttgtggacctgcaatattattgaaggaattgaaggcaatcgttttgccatgtacttcaaaattcaccatgcgatggtcgatggcgttgctggtatgcggttaattgaaaaatcactctcccatgatgtaacagaaaaaagtatcgtgccaccttggtgtgttgagggaaaacgtgcaaagcgcttaagagaacctaaaacaggtaaaattaagaaaatcatgtctggtattaagagtcagcttcaggcgacacccacagtcattcaagagctttctcagacagtatttaaagatattggacgtaatcctgatcatgtttcaagctttcaggcgccttgttctattttgaatcagcgtgtgagctcatcgcgacgttttgcagcacagtcttttgacctagatcgttttcgtaatattgccaaatcgttgaatgtgaccattaatgatgttgtactagcggtatgttctggtgcattacgtgcgtatttgatgagtcataatagtttgccttcaaaaccattaattgccatggttccagcctctattcgcaatgacgattcagatgtcagcaaccgtattacgatgattctggcaaatttggcaacccacaaagatgatcctttacaacgtcttgaaattatccgccgtagtgttcaaaactcaaagcaacgcttcaaacgtatgaccagcgatcagattctaaattatagtgctgtcgtatatggccctgcaggactcaacataatttctggcatgatgccaaaacgccaagccttcaatctggttatttccaatgtgcctggcccaagagagccactttactggaatggtgccaaacttgatgcactctacccagcttcaattgtattagacggtcaagcattgaatattacaatgaccagttatttagataaacttgaagttggtttgattgcatgccgtaatgcattgccaagaatgcagaatttactgacacatttagaagaagaaattcaactatttgaaggcgtaattgcaaagcaggaagatattaaaacagccaattaaggatcgcaaaaaaccccgcttcggcggggttttttcgccctgtggcgccggtgatgccggccacgatgcgtccggcgtagaggatcgagatcgtttaggcaccccaggctttacactttatgcttccggctcgtataatgtgtggaattgtgagcggataacaatttcaaaattcaaaggaaggatctctgcagtaggaggaattaaccatgagttatactgtcggtacctatttagcggagcggcttgtccagattggtctcaagcatcacttcgcagtcgcgggcgactacaacctcgtccttcttgacaacctgcttttgaacaaaaacatggagcaggtttattgctgtaacgaactgaactgcggtttcagtgcagaaggttatgctcgtgccaaaggcgcagcagcagccgtcgttacctacagcgtcggtgcgctttccgcatttgatgctatcggtggcgcctatgcagaaaaccttccggttatcctgatctccggtgctccgaacaacaatgaccacgctgctggtcacgtgttgcatcacgctcttggcaaaaccgactatcactatcagttggaaatggccaagaacatcacggccgccgctgaagcgatttataccccggaagaagctccggctaaaatcgatcacgtgattaaaactgctcttcgtgagaagaagccggtttatctcgaaatcgcttgcaacattgcttccatgccctgcgccgctcctggaccggcaagcgcattgttcaatgacgaagccagcgacgaagcttctttgaatgcagcggttgaagaaaccctgaaattcatcgccnaccgcgacaaagttgccgtcctcgtcggcagcaagctgcgcgcagctggtgctgaagaagctgctgtcaaatttgctgatgctcttggtggcgcagttgctaccatggctgctgcaaaaagcttcttcccagaagaaaacccgcattacatcggtacctcatggggtgaagtcagctatccgggcgttgaaaagacgatgaaagaagccgatgcggttatcgctctggctcctgtctttaacgactactccaccactggttggacggatattcctgatcctaagaaactggttctcgctgaaccgcgttctgtcgtcgttaacggcattcgcttccccagcgtccatctgaaagactatctgacccgtttggctcagaaagtttccaagaaaaccggtgctttggacttcttcaaatccctcaatgcaggtgaactgaagaaagccgctccggctgatccgagtgctccgttggtcaacgcagaaatcgcccgtcaggtcgaagctcttctgaccccgaacacgacggttattgctgaaaccggtgactcttggttcaatgctcagcgcatgaagctcccgaacggtgctcgcgttgaatatgaaatgcagtggggtcacattggttggtccgttcctgccgccttcggttatgccgtcggtgctccggaacgtcgcaacatcctcatggttggtgatggttccttccagctgacggctcaggaagtcgctcagatggttcgcctgaaactgccggttatcatcttcttgatcaataactatggttacaccatcgaagttatgatccatgatggtccgtacaacaacatcaagaactgggattatgccggtctgatggaagtgttcaacggtaacggtggttatgacagcggtgctggtaaaggcctgaaggctaaaaccggtggcgaactggcagaagctatcaaggttgctctggcaaacaccgacggcccaaccctgatcgaatgcttcatcggtcgtgaagactgcactgaagaattggtcaaatggggtaagcgcgttgctgccgccaacagccgtaagcctgttaacaagctcctctaggagcggccgccaccgcggaggaggaatgagtaatggcttcttcaactttttatattcctttcgtcaacgaaatgggcgaaggttcgcttgaaaaagcaatcaaggatcttaacggcagcggctttaaaaatgcgctgatcgtttctgatgctttcatgaacaaatccggtgttgtgaagcaggttgctgacctgttgaaagcacagggtattaattctgctgtttatgatggcgttatgccgaacccgactgttaccgcagttctggaaggccttaagatcctgaaggataacaattcagacttcgtcatctccctcggtggtggttctccccatgactgcgccaaagccatcgctctggtcgcaaccaatggtggtgaagtcaaagactacgaaggtatcgacaaatctaagaaacctgccctgcctttgatgtcaatcaacacgacggctggtacggcttctgaaatgacgcgtttctgcatcatcactgatgaagtccgtcacgttaagatggccattgttgaccgtcacgttaccccgatggtttccgtcaacgatcctctgttgatggttggtatgccaaaaggcctgaccgccgccaccggtatggatgctctgacccacgcatttgaagcttattcttcaacggcagctactccgatcaccgatgcttgcgctttgaaagcagcttccatgatcgctaagaatctgaagaccgcttgcgacaacggtaaggatatgccggctcgtgaagctatggcttatgcccaattcctcgctggtatggccttcaacaacgcttcgcttggttatgtccatgctatggctcaccagttgggcggttactacaacctgccgcatggtgtctgcaacgctgttctgcttccgcatgttctggcttataacgcctctgtcgttgctggtcgtctgaaagacgttggtgttgctatgggtctcgatatcgccaatctcggtgataaagaaggcgcagaagccaccattcaggctgttcgcgatctggctgcttccattggtattccagcaaacctgaccgagctgggtgctaagaaagaagatgtgccgcttcttgctgaccacgctctgaaagatgcttgtgctctgaccaacccgcgtcagggtgatcagaaagaagttgaagaactcttcctgagcgctttctaaggatctaattcaaaggaggccatcctatggcggacacgttattgattctgggtgatagcctgagcgccgggtatcgaatgtctgccagcgcggcctggcctgccttgttgaatgataagtggcagagtaaaacgtcggtagttaatgccagcatcagcggcgacacctcgcaacaaggactggcgcgccttccggctctgctgaaacagcatcagccgcgttgggtgctggttgaactgggcggcaatgacggtttgcgtggttttcagccacagcaaaccgagcaaacgctgcgccagattttgcaggatgtcaaagccgccaacgctgaaccattgttaatgcaaatacgtctgcctgcaaactatggtcgccgttataatgaagcctttagcgccatttaccccaaactcgccaaagagtttgatgttccgctgctgcccttttttatggaagaggtctacctcaagccacaatggatgcaggatgacggtattcatcccaaccgcgacgcccagccgtttattgccgactggatggcgaagcagttgcagcctttagtaaatcatgactcataaggatccaatctcgagtaaggatctccaggcatcaaataaaacgaaaggctcagtcgaaagactgggcctttcgttttatctgttgtttgtcggtgaacgctctctactagagtcacactggctcaccttcgggtgggcctttctgcgtttatacctagggcgttcggctgcggcgagcggtatcagctcactcaaaggcggtaatacggttatccacagaatcaggggataacgcaggaaagaacatgtgagcaaaaggccagcaaaaggccaggaaccgtaaaaaggccgcgttgctggcgtttttccataggctccgcccccctgacgagcatcacaaaaatcgacgctcaagtcagaggtggcgaaacccgacaggactataaagataccaggcgtttccccctggaagctccctcgtgcgctctcctgttccgaccctgccgcttaccggatacctgtccgcctttctcccttcgggaagcgtggcgctttctcatagctcacgctgtaggtatctcagttcggtgtaggtcgttcgctccaagctgggctgtgtgcacgaaccccccgttcagcccgaccgctgcgccttatccggtaactatcgtcttgagtccaacccggtaagacacgacttatcgccactggcagcagccactggtaacaggattagcagagcgaggtatgtaggcggtgctacagagttcttgaagtggtggcctaactacggctacactagaaggacagtatttggtatctgcgctctgctgaagccagttaccttcggaaaaagagttggtagctcttgatccggcaaacaaaccaccgctggtagcggtggtttttttgtttgcaagcagcagattacgcgcagaaaaaaaggatctcaagaagatcctttgatcttttctacggggtctgacgctcagtggaacgaaaactcacgttaagggattttggtcatgactagtgcttggattctcaccaataaaaaacgcccggcggcaaccgagcgttctgaacaaatccagatggagttctgaggtcattactggatctatcaacaggagtccaagcgagctcgtaaacttggtctgacagttaccaatgcttaatcagtgaggcacctatctcagcgatctgtctatttcgttcatccatagttgcctgactccccgtcgtgtagataactacgatacgggagggcttaccatctggccccagtgctgcaatgataccgcgagacccacgctcaccggctccagatttatcagcaataaaccagccagccggaagggccgagcgcagaagtggtcctgcaactttatccgcctccatccagtctattaattgttgccgggaagctagagtaagtagttcgccagttaatagtttgcgcaacgttgttgccattgctacaggcatcgtggtgtcacgctcgtcgtttggtatggcttcattcagctccggttcccaacgatcaaggcgagttacatgatcccccatgttgtgcaaaaaagcggttagctccttcggtcctccgatcgttgtcagaagtaagttggccgcagtgttatcactcatggttatggcagcactgcataattctcttactgtcatgccatccgtaagatgcttttctgtgactggtgagtactcaaccaagtcattctgagaatagtgtatgcggcgaccgagttgctcttgcccggcgtcaatacgggataataccgcgccacatagcagaactttaaaagtgctcatcattggaaaacgttcttcggggcgaaaactctcaaggatcttaccgctgttgagatccagttcgatgtaacccactcgtgcacccaactgatcttcagcatcttttactttcaccagcgtttctgggtgagcaaaaacaggaaggcaaaatgccgcaaaaaagggaataagggcgacacggaaatgttgaatactcatactcttcctttttcaatattattgaagcatttatcagggttattgtctcatgagcggatacatatttgaatgtatttagaaaaataaacaaataggggttccgcgcacatttccccgaaaagtgccacct";
			sequence.sequenceUser = "";
			sequence.sequenceFeatures = new ArrayCollection();
			sequence.sequenceFeatures.addItem(new SequenceFeature(1500, 1575, 1, new Feature("lacUV5 promoter", null, null, 0, "promoter")));
			sequence.sequenceFeatures.addItem(new SequenceFeature(1516, 1579, 1, new Feature("lac operator", null, null, 0, "misc_binding")));
			sequence.sequenceFeatures.addItem(new SequenceFeature(1595, 1614, 1, new Feature("RBS", null, null, 0, "RBS")));
			sequence.sequenceFeatures.addItem(new SequenceFeature(1615, 3300, 1, new Feature("fadD", null, null, 0, "CDS")));
			sequence.sequenceFeatures.addItem(new SequenceFeature(3321, 4697, 1, new Feature("atfA", null, null, 0, "CDS")));
			sequence.sequenceFeatures.addItem(new SequenceFeature(3443, 3443, 1, new Feature("silentMut-removeBglII", null, null, 0, "misc_feature")));
			sequence.sequenceFeatures.addItem(new SequenceFeature(4702, 4735, 1, new Feature("BBa_B1002_term", null, null, 0, "terminator")));
			sequence.sequenceFeatures.addItem(new SequenceFeature(4787, 4862, 1, new Feature("lacUV5 promoter", null, null, 0, "promoter")));
			sequence.sequenceFeatures.addItem(new SequenceFeature(4803, 4879, 1, new Feature("lac operator", null, null, 0, "misc_binding")));
			sequence.sequenceFeatures.addItem(new SequenceFeature(4907, 6612, 1, new Feature("pdc", null, null, 0, "CDS")));
			sequence.sequenceFeatures.addItem(new SequenceFeature(6646, 7797, 1, new Feature("adhB", null, null, 0, "CDS")));
			sequence.sequenceFeatures.addItem(new SequenceFeature(7824, 8375, 1, new Feature("lTesA", null, null, 0, "CDS")));
			sequence.sequenceFeatures.addItem(new SequenceFeature(8400, 8528, 1, new Feature("dbl term", null, null, 0, "terminator")));
			sequence.sequenceFeatures.addItem(new SequenceFeature(9350, 9455, 1, new Feature("T0", null, null, 0, "terminator")));
			sequence.sequenceFeatures.addItem(new SequenceFeature(8662, 9344, -1, new Feature("colE1", null, null, 0, "rep_origin")));
			sequence.sequenceFeatures.addItem(new SequenceFeature(9485, 10340, -1, new Feature("Amp", null, null, 0, "misc_marker")));
			sequence.sequenceFeatures.addItem(new SequenceFeature(49, 1131, -1, new Feature("lacI", null, null, 0, "CDS")));
			
			return sequence;
		}
	}
}
