package ni;

public class M1 
{
	
	public static void main(String[] args)
	{
		int[] arr = new int[]{1,2,3,4,5,6,7,8,9,};
		int a;
		int b;
		//System.out.println(arr.length);
		for(int i = 0; i <= arr.length-1; i++)
		{
			a = arr[i];
			for(int j = 0; j <= arr.length-1; j++)
			{
				b = arr[j];
				int c = a - b;
				if(c == a || c == b || a == b || a < b)
				{
					//System.out.println("error");
				}
				else
				{
					for(int x = 0; x <= arr.length-1; x++)
					{
						int d = arr[x];
						for(int y = 0; y <= arr.length-1; y++)
						{
							int e = arr[y];
							int z = d % e;
							if(z != 0)
							{
								//System.out.println("error");
							}
							else
							{
								int f = d / e;
								if(f == d || f == e || d == e)
								{
									//System.out.println("error");
								}
								else
								{
									for(int m = 0; m <= arr.length-1; m++)
									{
										int g = arr[m];
										for(int n = 0; n <= arr.length-1; n++)
										{
											int h = arr[n];
											int w = g + h;
											if(w == g || w == h || g == h || w > 9)
											{
												//System.out.println("error");
											}
											else
											{
												if(w != c * f || c == f || c == w || f == w ||a==d||a==g||d==g||b==e||b==h||e==h||a==e||a==f
														||a==w||a==h||a==g||d==b||b==e||b==f||b==g||b==h||b==w||c==d||c==e||c==f||c==g||c==h
														||c==w||d==w||g==f)
												{
													//System.out.println("sorry");
												}
												else
												{
													System.out.print("第一行：");
													System.out.print(a);
													System.out.print(b);
													System.out.println(c);
													System.out.print("第二行：");
													System.out.print(d);
													System.out.print(e);
													System.out.println(f);
													System.out.print("第三行：");
													System.out.print(g);
													System.out.print(h);
													System.out.println(w);
												}
											}
										}
									}								
								}
							}	
						}
					}					
				}
			}
		}	
	}
}
